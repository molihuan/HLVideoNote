import 'dart:convert';
import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/embeds/image/editor/image_embed_types.dart';
import 'package:get/get.dart';

import '../../../models/note_model/base_note.dart';

import '../../media_display/base_media_display_controller.dart';
import '../base_editor_controller.dart';
import 'state.dart';
import 'widgets/quill_editor_toolbar_widget.dart';
import 'widgets/quill_editor_widget.dart';
import 'widgets/link_blockembed.dart';

class FlutterQuillEditorController extends GetxController
    with BaseEditorController {
  FlutterQuillEditorController();

  final state = FlutterQuillEditorState();

  //创建富文本控制器
  late QuillController quillController = QuillController.basic();

  final _editorFocusNode = FocusNode();

  ///工具栏视图
  late QuillEditorToolbarWidget quillToolbarWidget;

  //富文本编辑器视图
  late QuillEditorWidget quillEditorWidget;

  @override
  void setMediaDisplayController(BaseMediaDisplayController controller) {
    super.setMediaDisplayController(controller);

    quillToolbarWidget = QuillEditorToolbarWidget(
      quillController: quillController,
      flutterQuillEditorController: this,
      mediaDisplayController: mediaDisplayController,
      focusNode: _editorFocusNode,
    );

    quillEditorWidget = QuillEditorWidget(
      quillController: quillController,
      flutterQuillEditorController: this,
      mediaDisplayController: mediaDisplayController,
      focusNode: _editorFocusNode,
    );
  }

  ///获取笔记
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
    // LogUtil.d("加载的笔记为:" + baseNote.toJson().toString());
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

  /// When inserting an image
  OnImageInsertCallback get onImageInsert {
    return (image, controller) async {};
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

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    setNoteContent();
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所
  @override
  void onReady() {
    super.onReady();
  }

  /// 在 [onDelete] 方法之前调用。
  @override
  void onClose() {
    super.onClose();
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool insertImage(String pos) {
    if (pos.isNotEmpty) {
      final index = quillController.selection.baseOffset;
      final length = quillController.selection.extentOffset - index;
      quillController.replaceText(index, length, BlockEmbed.image(pos), null);
      return true;
    }
    return false;
  }

  @override
  bool insertTimeAnchor() {
    // TODO: implement insertTimeAnchor
    throw UnimplementedError();
  }

  @override
  bool insertVideoAnchor() {
    Duration currentDuration = mediaDisplayController.getCurrentPos();
    //去除毫秒
    String currentDurationStr = currentDuration.toString().split('.').first;

    insertLinkBlockEmbed(quillController, currentDurationStr, () {
      mediaDisplayController.setCurrentPos(currentDuration);
    });

    return true;
  }

  @override
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

  @override
  QuillEditorWidget getQuillEditorWidget() {
    return quillEditorWidget;
  }

  @override
  QuillEditorToolbarWidget getQuillToolbarWidget() {
    return quillToolbarWidget;
  }
}
