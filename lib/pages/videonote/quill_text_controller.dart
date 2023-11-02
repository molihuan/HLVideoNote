import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fresh_quill_extensions/fresh_quill_extensions.dart';
import 'package:fresh_quill_extensions/presentation/models/config/toolbar/buttons/camera.dart';
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
   * 保存笔记
   */
  bool saveNote() {
    var deltaJson = quillController.document.toDelta().toJson();
    print(deltaJson);

    String jsonString = jsonEncode(deltaJson);

    final file = File(state.noteFilePath);
    try {
      file.writeAsStringSync(jsonString);
      return true;
    } catch (e) {
      print('文件写入失败: $e');
      return false;
    }
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
    // controller.document.insert(controller.selection.extentOffset, '\n');
    // controller.updateSelection(
    //   TextSelection.collapsed(
    //     offset: controller.selection.extentOffset + 1,
    //   ),
    //   ChangeSource.LOCAL,
    // );

    controller.document.insert(
      controller.selection.extentOffset,
      LinkBlockEmbed(editValue: string),
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
          iconData: Icons.screenshot,
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
          iconData: Icons.flag,
          onTap: () {
            insertVideoAnchor(quillController);
          }),
      QuillCustomButton(
          iconData: Icons.image,
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => InsertImageDialog(),
            );
          }),
      QuillCustomButton(iconData: Icons.movie_creation, onTap: () {}),
      QuillCustomButton(iconData: Icons.photo_camera, onTap: () {}),
      QuillCustomButton(iconData: Icons.find_in_page, onTap: () {}),
      QuillCustomButton(iconData: Icons.mic, onTap: () {}),
      QuillCustomButton(iconData: Icons.music_note, onTap: () {}),
      QuillCustomButton(
          iconData: Icons.live_tv,
          onTap: () {
            insertVideoBlockEmbed(
                quillController, "http://file.cccyun.cc/Demo/mv.mp4");
          }),
      QuillCustomButton(
          iconData: Icons.save,
          onTap: () {
            bool result = saveNote();
            if (result) {
              Fluttertoast.showToast(msg: "保存成功");
            } else {
              Fluttertoast.showToast(msg: "保存失败");
            }
          }),
    ];

    // var toolbar = QuillToolbar.basic(
    //     controller: quillController!,
    //     embedButtons: FlutterQuillEmbeds.buttons(
    //       showImageButton: false,
    //       showCameraButton: true,
    //       showVideoButton: false,
    //       showFormulaButton: true,
    //       // provide a callback to enable picking images from device.
    //       // if omit, "image" button only allows adding images from url.
    //       // same goes for videos.
    //       // onImagePickCallback: _onImagePickCallback,
    //       // onVideoPickCallback: _onVideoPickCallback,
    //       // uncomment to provide a custom "pick from" dialog.
    //       // mediaPickSettingSelector: _selectMediaPickSetting,
    //       // uncomment to provide a custom "pick from" dialog.
    //       // cameraPickSettingSelector: _selectCameraPickSetting,
    //     ),
    //     showAlignmentButtons: true,
    //     afterButtonPressed: _focusNode.requestFocus,
    //     customButtons: customQuillCustomButtons);
    var toolbar = QuillToolbar(
      configurations: QuillToolbarConfigurations(
        customButtons: customQuillCustomButtons,
        showAlignmentButtons: true,
        embedButtons: FlutterQuillEmbeds.toolbarButtons(
          imageButtonOptions: QuillToolbarImageButtonOptions(
            onImagePickCallback: (file) async {
              return file.path;
            },
          ),
        ),
        buttonOptions: QuillToolbarButtonOptions(
          base: QuillToolbarBaseButtonOptions(
            afterButtonPressed: _focusNode.requestFocus,
          ),
        ),
      ),
    );
    if (kIsWeb) {
      toolbar = QuillToolbar(
        configurations: QuillToolbarConfigurations(
          customButtons: customQuillCustomButtons,
          showAlignmentButtons: true,
          embedButtons: FlutterQuillEmbeds.toolbarButtons(
            imageButtonOptions: QuillToolbarImageButtonOptions(
              onImagePickCallback: (file) async {
                return file.path;
              },
            ),
          ),
          buttonOptions: QuillToolbarButtonOptions(
            base: QuillToolbarBaseButtonOptions(
              afterButtonPressed: _focusNode.requestFocus,
            ),
          ),
        ),
      );
    }
    if (_isDesktop()) {
      toolbar = QuillToolbar(
        configurations: QuillToolbarConfigurations(
          customButtons: customQuillCustomButtons,
          showAlignmentButtons: true,
          embedButtons: FlutterQuillEmbeds.toolbarButtons(
            imageButtonOptions: QuillToolbarImageButtonOptions(
              onImagePickCallback: (file) async {
                return file.path;
              },
            ),
            cameraButtonOptions: QuillToolbarCameraButtonOptions(
              onImagePickCallback: (File file) async {
                return file.path;
              },
              onVideoPickCallback: (File file) async {
                return file.path;
              },
            ),
          ),
          buttonOptions: QuillToolbarButtonOptions(
            base: QuillToolbarBaseButtonOptions(
              afterButtonPressed: _focusNode.requestFocus,
            ),
          ),
        ),
      );
    }
    return toolbar;
  }

  /**
   * 构建富文本编辑器
   */
  QuillEditor buildQuillEditor() {
    var quillEditor = QuillEditor(
      configurations: QuillEditorConfigurations(
        placeholder: '添加内容',
        padding: EdgeInsets.all(5),
        enableSelectionToolbar: isMobile(),
        onImagePaste: _onImagePaste,
        onTapUp: (details, p1) {
          return _onTripleClickSelection();
        },
        embedBuilders: [
          ...FlutterQuillEmbeds.editorBuilders(),
          LinkEmbedBuilder(videoNoteController: videoNoteController)
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
      ),
      scrollController: ScrollController(),
      focusNode: _focusNode,
    );
    if (kIsWeb) {
      quillEditor = QuillEditor(
        configurations: QuillEditorConfigurations(
          placeholder: '添加内容',
          padding: EdgeInsets.all(5),
          enableSelectionToolbar: isMobile(),
          onImagePaste: _onImagePaste,
          onTapUp: (details, p1) {
            return _onTripleClickSelection();
          },
          embedBuilders: [
            ...FlutterQuillEmbeds.editorsWebBuilders(),
            LinkEmbedBuilder(videoNoteController: videoNoteController)
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
        ),
        scrollController: ScrollController(),
        focusNode: _focusNode,
      );
    }

    return quillEditor;
  }

  //获取视频地址或路径
  String? getNoteFilePath() {
    Map? arguments = videoNoteController.getArguments();
    if (arguments == null) {
      return null;
    }
    var noteFilePath = arguments['noteFilePath'];
    return noteFilePath == null ? null : noteFilePath as String;
  }

  /// 在 widget 内存中分配后立即调用。
  void onInit() {
    state.noteFilePath = getNoteFilePath();
    if (state.noteFilePath != null) {
      loadNoteFileData(state.noteFilePath);
    }
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所

  void onReady() {}

  /// 在 [onDelete] 方法之前调用。
  void onClose() {}

  /// dispose 释放内存
  void dispose() {}
}
