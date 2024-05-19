import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../../../common/utils/common_tool.dart';
import '../../../common/utils/file_tool.dart';
import '../../../dao/data_manager.dart';
import '../../../models/note_model/base_note.dart';
import '../widgets/link_blockembed.dart';
import '../widgets/my_quill_toolbar.dart';
import 'video_player_controller.dart';

///选择类型
enum _SelectionType {
  none,
  word,
  // line,
}

///状态
class QuillTextState {
  /// 笔记
  final _baseNote = BaseNote(
          noteDependMediaPos: '/root/baseNote/1.mp4',
          noteCfgPos: '/root/baseNote/1.hlcfg',
          noteTitle: '')
      .obs;

  void setBaseNote(value) {
    _baseNote.value = value;
  }

  BaseNote getBaseNote() {
    return _baseNote.value;
  }

  Rx<BaseNote> getRxBaseNote() {
    return _baseNote;
  }

  ///是否显示更多toolbar按钮
  final _showMoreToolbarBtn = DataManager.getShowMoreToolbarBtn().obs;

  set showMoreToolbarBtn(value) => _showMoreToolbarBtn.value = value;

  bool get showMoreToolbarBtn => _showMoreToolbarBtn.value;
}

///富文本控制器
class QuillTextController extends GetxController {
  final state = QuillTextState();

  final videoPlayerController = Get.find<VideoPlayerController>();

  //创建富文本控制器
  late QuillController quillController = QuillController.basic();

  final _editorFocusNode = FocusNode();

  ///工具栏
  late MyQuillToolbar quillToolbar = MyQuillToolbar(
      quillController: quillController, focusNode: _editorFocusNode);

  //创建富文本编辑器
  late final QuillEditor quillEditor = buildQuillEditor();

  //获取笔记
  BaseNote? getBaseNote() {
    Map? arguments = getArguments();
    if (arguments == null) {
      return null;
    }
    BaseNote baseNote;
    try {
      baseNote = arguments[BaseNote.flag] as BaseNote;
    } catch (e) {
      LogUtil.e("无法转换为BaseNote");
      return null;
    }

    state.setBaseNote(baseNote);

    return baseNote;
  }

  ///获取传入页面的参数
  Map? getArguments() {
    if (Get.arguments != null) {
      final arguments = Get.arguments as Map;
      return arguments;
    }
    return null;
  }

  /// 加载笔记数据
  Document? loadNoteDataFile(String filePath) {
    File noteDataFile = File(filePath);

    try {
      var contents = noteDataFile.readAsStringSync();
      var json = jsonDecode(contents);
      Document doc = Document.fromJson(json);
      LogUtil.d("读取到的笔记数据源文件为:$contents");
      LogUtil.d("转换json后:$json");
      return doc;
    } catch (error) {
      LogUtil.e('读取文件错误,文件不是Delta格式:$error');
      return null;
    }
  }

  ///保存笔记
  bool saveNote() {
    var deltaJson = quillController.document.toDelta().toJson();
    String jsonString = jsonEncode(deltaJson);
    final file = File(state.getBaseNote().noteDataPos);
    LogUtil.d("保存位置:${file.absolute}");
    LogUtil.d("保存数据为:$deltaJson");
    try {
      file.writeAsStringSync(jsonString);
      return true;
    } catch (e) {
      LogUtil.d('保存数据失败: $e');
      return false;
    }
  }

  /// 插入视频节点
  void insertVideoAnchor(QuillController quillController) {
    Duration currentDuration = videoPlayerController.getCurrentDuration();
    //去除毫秒
    String currentDurationStr = currentDuration.toString().split('.').first;

    insertLinkBlockEmbed(quillController, currentDurationStr, () {
      videoPlayerController.playerSeek(duration: currentDuration);
    });
  }

  /// 插入图片(本地和网络)
  void insertImageBlockEmbed(String? source) {
    if (source != null && source.isNotEmpty) {
      final index = quillController.selection.baseOffset;
      final length = quillController.selection.extentOffset - index;
      quillController.replaceText(
          index, length, BlockEmbed.image(source), null);
    }
  }

  /// 插入视频(本地和网络)
  void insertVideoBlockEmbed(QuillController controller, String? source) {
    if (source != null && source.isNotEmpty) {
      final index = controller.selection.baseOffset;
      final length = controller.selection.extentOffset - index;
      controller.replaceText(index, length, BlockEmbed.video(source), null);
    }
  }

  /// 插入自定义链接
  void insertLinkBlockEmbed(QuillController controller, String string,
      void Function() linkBlockEmbedClick) {
    controller.document.insert(
      controller.selection.extentOffset,
      LinkBlockEmbed(editValue: string),
    );

    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.local,
    );

    controller.document.insert(controller.selection.extentOffset, '\n');
    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.local,
    );
  }

  /// 复制粘贴图片(网络)
  Future<String?> _onImagePaste(Uint8List imageBytes) async {
    String imgDir = state.getBaseNote().noteImgPos;
    String imgName = CommonTool.getCurrentTime() + ".jpeg";
    String? imgFilePath = await FileTool.saveImage(imageBytes, imgDir, imgName);
    if (imgFilePath == null) {
      return null;
    }
    LogUtil.d("图片保存路径为:$imgFilePath");
    return imgFilePath;
  }

  /// 也是三次点击的部分
  Timer? _selectAllTimer;
  _SelectionType _selectionType = _SelectionType.none;

  /// 三次点击
  bool _onTripleClickSelection() {
    final controller = quillController;
    _selectAllTimer?.cancel();
    _selectAllTimer = null;

    if (controller.selection.isCollapsed) {
      _selectionType = _SelectionType.none;
    }

    if (_selectionType == _SelectionType.none) {
      _selectionType = _SelectionType.word;
      _selectAllTimer = Timer(const Duration(milliseconds: 900), () {
        _selectionType = _SelectionType.none;
      });
      return false;
    }

    if (_selectionType == _SelectionType.word) {
      final child = controller.document.queryChild(
        controller.selection.baseOffset,
      );
      final offset = child.node?.documentOffset ?? 0;
      final length = child.node?.length ?? 0;

      final selection = TextSelection(
        baseOffset: offset,
        extentOffset: offset + length,
      );
      controller.updateSelection(selection, ChangeSource.remote);
      _selectionType = _SelectionType.none;
      _selectAllTimer = Timer(const Duration(milliseconds: 900), () {
        _selectionType = _SelectionType.none;
      });
      return true;
    }
    return false;
  }

  /// When inserting an image
  OnImageInsertCallback get onImageInsert {
    return (image, controller) async {};
  }

  final FocusNode _focusNode = FocusNode();

  ///构建富文本编辑器
  QuillEditor buildQuillEditor() {
    var quillEditor = QuillEditor(
      configurations: QuillEditorConfigurations(
        placeholder: '添加内容',
        padding: EdgeInsets.all(5),
        onImagePaste: _onImagePaste,
        onTapUp: (details, p1) {
          return _onTripleClickSelection();
        },
        embedBuilders: [
          ...FlutterQuillEmbeds.editorBuilders(),
          LinkEmbedBuilder(videoPlayerController: videoPlayerController)
        ],
        customStyles: DefaultStyles(
          h1: DefaultTextBlockStyle(
              const TextStyle(
                fontSize: 32,
                color: Colors.black,
                height: 1.15,
                fontWeight: FontWeight.w300,
              ),
              const VerticalSpacing(16, 0),
              const VerticalSpacing(0, 0),
              null),
          sizeSmall: const TextStyle(fontSize: 9),
          subscript: const TextStyle(
            fontFamily: 'SF-UI-Display',
            fontFeatures: [FontFeature.subscripts()],
          ),
          superscript: const TextStyle(
            fontFamily: 'SF-UI-Display',
            fontFeatures: [FontFeature.superscripts()],
          ),
        ),
        controller: quillController,
      ),
      scrollController: ScrollController(),
      focusNode: _focusNode,
    );
    if (kIsWeb) {
      quillEditor = QuillEditor(
        configurations: QuillEditorConfigurations(
          placeholder: '添加内容',
          padding: EdgeInsets.all(5),
          onImagePaste: _onImagePaste,
          onTapUp: (details, p1) {
            return _onTripleClickSelection();
          },
          embedBuilders: [
            ...FlutterQuillEmbeds.editorWebBuilders(),
            LinkEmbedBuilder(videoPlayerController: videoPlayerController)
          ],
          customStyles: DefaultStyles(
            h1: DefaultTextBlockStyle(
                const TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  height: 1.15,
                  fontWeight: FontWeight.w300,
                ),
                const VerticalSpacing(16, 0),
                const VerticalSpacing(0, 0),
                null),
            sizeSmall: const TextStyle(fontSize: 9),
          ),
          controller: quillController,
        ),
        scrollController: ScrollController(),
        focusNode: _focusNode,
      );
    }

    return quillEditor;
  }

  ///设置笔记内容
  void setNoteContent({BaseNote? baseNote}) {
    baseNote = baseNote ?? getBaseNote();
    if (baseNote == null) {
      return;
    }

    Document? doc = loadNoteDataFile(baseNote.noteDataPos);
    if (doc == null) {
      return;
    }
    quillController.document = doc;
  }

  /// 在 widget 内存中分配后立即调用,这和Widget build(BuildContext context)异步,不适合初始化一些耗时操作。
  @override
  void onInit() async {
    super.onInit();
    setNoteContent();
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所
  @override
  void onReady() {}

  /// 在 [onDelete] 方法之前调用。
  @override
  void onClose() {}

  /// dispose 释放内存
  void dispose() {
    super.dispose();
  }
}
