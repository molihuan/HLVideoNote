import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_quill_extensions/shims/dart_ui_real.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:note/common/utils/file_tool.dart';
import 'package:note/pages/home/widgets/create_note_video_dialog.dart';
import 'package:note/pages/videonote/controller.dart';
import 'package:note/pages/videonote/insert_image_dialog.dart';
import 'package:note/pages/videonote/state.dart';
import 'package:note/pages/videonote/video_player_controller.dart';
import 'package:note/pages/videonote/widgets/link_blockembed.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

enum _SelectionType {
  none,
  word,
  // line,
}

/**
 * 富文本控制器
 */
class QuillTextController {
  QuillTextController({required this.videoNoteController, required this.state});
  VideoNoteController videoNoteController;
  VideoNoteState state;

  //创建富文本编辑器
  late final QuillEditor quillEditor = buildQuillEditor();

  // late final QuillEditor quillEditor = QuillEditor.basic(
  //   controller: quillController,
  //   embedBuilders: [...FlutterQuillEmbeds.builders(), LinkEmbedBuilder()],
  //   readOnly: false, // 为 true 时只读
  //   autoFocus: true,
  //   padding: EdgeInsets.all(10),
  // );

  //创建富文本控制器
  late QuillController quillController = QuillController.basic();

  final FocusNode _focusNode = FocusNode();

  Timer? _selectAllTimer;
  _SelectionType _selectionType = _SelectionType.none;

  VideoPlayerController getVideoPlayerController() {
    return videoNoteController.videoPlayerController;
  }

  /**
   * 加载笔记数据
   */
  void loadNoteFileData(String noteFilePath) {
    final noteFile = File(noteFilePath);
    try {
      // final result = await rootBundle.loadString(isDesktop()
      //     ? 'assets/sample_data_nomedia.json'
      //     : 'assets/sample_data.json');
      final contents = noteFile.readAsStringSync();
      final doc = Document.fromJson(jsonDecode(contents));
      quillController = QuillController(
          document: doc, selection: const TextSelection.collapsed(offset: 0));
    } catch (error) {
      final doc = Document()..insert(0, '读取文件错误,文件不是Delta格式');
      quillController = QuillController(
          document: doc, selection: const TextSelection.collapsed(offset: 0));
    }
  }

  /**
   * 插入视频锚点
   */
  void insertVideoAnchor(QuillController quillController) {
    Duration currentDuration = videoNoteController.getCurrentDuration();
    //去除毫秒
    String currentDurationStr = currentDuration.toString().split('.').first;

    insertLinkBlockEmbed(quillController, currentDurationStr, () {
      videoNoteController.playerSeek(duration: currentDuration);
    });
  }

  /**
   * 插入图片(本地和网络)
   */
  void insertImageBlockEmbed(String? source) {
    if (source != null && source.isNotEmpty) {
      final index = quillController.selection.baseOffset;
      final length = quillController.selection.extentOffset - index;
      quillController.replaceText(
          index, length, BlockEmbed.image(source), null);
    }
  }

  /**
   * 插入视频(本地和网络)
   */
  void insertVideoBlockEmbed(QuillController controller, String? source) {
    if (source != null && source.isNotEmpty) {
      final index = controller.selection.baseOffset;
      final length = controller.selection.extentOffset - index;
      controller.replaceText(index, length, BlockEmbed.video(source), null);
    }
  }

  /**
   * 插入自定义链接
   */
  void insertLinkBlockEmbed(QuillController controller, String string,
      void Function() linkBlockEmbedClick) {
    controller.document.insert(controller.selection.extentOffset, '\n');
    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.LOCAL,
    );

    controller.document.insert(
      controller.selection.extentOffset,
      LinkBlockEmbed(
          editValue: string, linkBlockEmbedClick: linkBlockEmbedClick),
    );

    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.LOCAL,
    );

    controller.document.insert(controller.selection.extentOffset, '\n');
    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.LOCAL,
    );
  }

  /**
   * 三击
   */
  bool _onTripleClickSelection() {
    final controller = quillController!;

    _selectAllTimer?.cancel();
    _selectAllTimer = null;

    // If you want to select all text after paragraph, uncomment this line
    // if (_selectionType == _SelectionType.line) {
    //   final selection = TextSelection(
    //     baseOffset: 0,
    //     extentOffset: controller.document.length,
    //   );

    //   controller.updateSelection(selection, ChangeSource.REMOTE);

    //   _selectionType = _SelectionType.none;

    //   return true;
    // }

    if (controller.selection.isCollapsed) {
      _selectionType = _SelectionType.none;
    }

    if (_selectionType == _SelectionType.none) {
      _selectionType = _SelectionType.word;
      _startTripleClickTimer();
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

      controller.updateSelection(selection, ChangeSource.REMOTE);

      // _selectionType = _SelectionType.line;

      _selectionType = _SelectionType.none;

      _startTripleClickTimer();

      return true;
    }

    return false;
  }

  void _startTripleClickTimer() {
    _selectAllTimer = Timer(const Duration(milliseconds: 900), () {
      _selectionType = _SelectionType.none;
    });
  }

  /**
   * 是否为桌面
   */
  bool _isDesktop() => !kIsWeb && !Platform.isAndroid && !Platform.isIOS;
  /**
   * 构建富文本工具栏
   */
  QuillToolbar buildQuillToolbar(BuildContext context) {
    List<QuillCustomButton> customQuillCustomButtons = [
      QuillCustomButton(
          icon: Icons.screenshot,
          onTap: () async {
            insertVideoAnchor(quillController);
            final Directory appDocumentsDir =
                await getApplicationDocumentsDirectory();
            print("截图保存路径为" + appDocumentsDir.path);

            videoNoteController.videoScreenShot(appDocumentsDir.path,
                (absolutePath) {
              insertImageBlockEmbed(absolutePath);
            });
          }),
      QuillCustomButton(
          icon: Icons.flag,
          onTap: () {
            insertVideoAnchor(quillController);
          }),
      QuillCustomButton(
          icon: Icons.image,
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => InsertImageDialog(),
            );
          }),
      QuillCustomButton(icon: Icons.movie_creation, onTap: () {}),
      QuillCustomButton(icon: Icons.photo_camera, onTap: () {}),
      QuillCustomButton(icon: Icons.find_in_page, onTap: () {}),
      QuillCustomButton(icon: Icons.mic, onTap: () {}),
      QuillCustomButton(icon: Icons.music_note, onTap: () {}),
      QuillCustomButton(
          icon: Icons.live_tv,
          onTap: () {
            insertVideoBlockEmbed(
                quillController, "http://file.cccyun.cc/Demo/mv.mp4");
          }),
      QuillCustomButton(
          icon: Icons.save,
          onTap: () {
            saveNote();
          }),
    ];

    var toolbar = QuillToolbar.basic(
        controller: quillController!,
        embedButtons: FlutterQuillEmbeds.buttons(
          showImageButton: false,
          showCameraButton: true,
          showVideoButton: false,
          showFormulaButton: true,
          // provide a callback to enable picking images from device.
          // if omit, "image" button only allows adding images from url.
          // same goes for videos.
          // onImagePickCallback: _onImagePickCallback,
          // onVideoPickCallback: _onVideoPickCallback,
          // uncomment to provide a custom "pick from" dialog.
          // mediaPickSettingSelector: _selectMediaPickSetting,
          // uncomment to provide a custom "pick from" dialog.
          // cameraPickSettingSelector: _selectCameraPickSetting,
        ),
        showAlignmentButtons: true,
        afterButtonPressed: _focusNode.requestFocus,
        customButtons: customQuillCustomButtons);
    if (kIsWeb) {
      toolbar = QuillToolbar.basic(
          controller: quillController!,
          embedButtons: FlutterQuillEmbeds.buttons(
            showImageButton: false,
            showCameraButton: false,
            showVideoButton: false,
            showFormulaButton: true,
            // onImagePickCallback: _onImagePickCallback,
            // webImagePickImpl: _webImagePickImpl,
          ),
          showAlignmentButtons: true,
          afterButtonPressed: _focusNode.requestFocus,
          customButtons: customQuillCustomButtons);
    }
    if (_isDesktop()) {
      toolbar = QuillToolbar.basic(
          controller: quillController!,
          embedButtons: FlutterQuillEmbeds.buttons(
            showImageButton: false,
            showCameraButton: false,
            showVideoButton: false,
            showFormulaButton: true,
            // onImagePickCallback: _onImagePickCallback,
            // filePickImpl: openFileSystemPickerForDesktop,
          ),
          showAlignmentButtons: true,
          afterButtonPressed: _focusNode.requestFocus,
          customButtons: customQuillCustomButtons);
    }
    return toolbar;
  }

  /**
   * 保存笔记
   */
  bool saveNote() {
    var json = quillController.document.toDelta().toJson();
    return FileTool.writeJson(state.noteFilePath, json);
  }

  /**
   * 复制粘贴图片(网络)
   */
  Future<String> _onImagePaste(Uint8List imageBytes) async {
    // Saves the image to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final file = await File(
            '${appDocDir.path}/${basename('${DateTime.now().millisecondsSinceEpoch}.png')}')
        .writeAsBytes(imageBytes, flush: true);
    print("_onImagePaste:保存路径" + file.path);
    return file.path.toString();
  }

  /**
   * 构建富文本编辑器
   */
  QuillEditor buildQuillEditor() {
    var quillEditor = QuillEditor(
      controller: quillController!,
      scrollController: ScrollController(),
      scrollable: true,
      focusNode: _focusNode,
      autoFocus: false,
      readOnly: false,
      placeholder: '添加内容',
      enableSelectionToolbar: isMobile(),
      expands: false,
      padding: EdgeInsets.all(5),
      onImagePaste: _onImagePaste,
      onTapUp: (details, p1) {
        return _onTripleClickSelection();
      },
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
      embedBuilders: [...FlutterQuillEmbeds.builders(), LinkEmbedBuilder()],
    );
    if (kIsWeb) {
      quillEditor = QuillEditor(
          controller: quillController!,
          scrollController: ScrollController(),
          scrollable: true,
          focusNode: _focusNode,
          autoFocus: false,
          readOnly: false,
          placeholder: '添加内容',
          expands: false,
          padding: EdgeInsets.zero,
          onTapUp: (details, p1) {
            return _onTripleClickSelection();
          },
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
          embedBuilders: [
            // ...defaultEmbedBuildersWeb,
            LinkEmbedBuilder()
          ]);
    }

    return quillEditor;
  }

  //获取视频地址或路径
  String? getNoteFilePath() {
    Map? arguments = videoNoteController.getArguments();
    if (arguments == null) {
      return null;
    }
    return arguments['noteFilePath'] as String;
  }

  /// 在 widget 内存中分配后立即调用。
  void onInit() {
    state.noteFilePath = getNoteFilePath();
    loadNoteFileData(state.noteFilePath);
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所

  void onReady() {}

  /// 在 [onDelete] 方法之前调用。
  void onClose() {}

  /// dispose 释放内存
  void dispose() {}
}
