import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_quill_extensions/presentation/embeds/embed_types/camera.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:note/common/utils/common_tool.dart';
import 'package:note/common/utils/file_tool.dart';
import 'package:note/models/note/base_note.dart';
import 'package:note/models/note/impl/local_note.dart';
import 'package:note/models/r_source.dart';
import 'package:note/models/read_media.dart';
import 'package:note/pages/home/widgets/note_list.dart';
import 'package:note/pages/videonote/controller/multi_split_controller.dart';
import 'package:note/pages/videonote/controller/video_player_controller.dart';
import 'package:note/pages/videonote/widgets/dialogs/insert_image_dialog.dart';
import 'package:note/pages/videonote/widgets/link_blockembed.dart';

enum _SelectionType {
  none,
  word,
  // line,
}

///状态
class QuillTextState {
  // 笔记源
  final _baseNote = Rx<BaseNote>(LocalNote(
      readMedia: ReadMedia(
          rsource: Rsource<String>(sourceType: SourceType.LOCAL, v: ""),
          readMediaType: ReadMediaType.video),
      noteFilePath: "",
      noteTitle: 'videoLocalNote',
      noteDescription: 'videoLocalNote',
      noteUpdateTime: DateTime.now()));

  set baseNote(value) => _baseNote.value = value;

  BaseNote get baseNote => _baseNote.value;
}

///富文本控制器
class QuillTextController extends GetxController {
  ///空内容
  static const String EMPTY_DOCUMENT = '[{"insert":" "}]';

  final state = QuillTextState();

  final videoPlayerController = Get.find<VideoPlayerController>();

  late final noteRouteMsg = state.baseNote.noteRouteMsg;

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

  /**
   * 加载笔记数据
   */
  void loadNoteFileData(String noteFilePath) {
    print(noteFilePath);
    final noteFile = File(noteFilePath);
    try {
      final contents = noteFile.readAsStringSync();
      final doc = Document.fromJson(jsonDecode(contents));
      print(contents);
      print(doc);
      quillController = QuillController(
          document: doc, selection: const TextSelection.collapsed(offset: 0));
    } catch (error) {
      // final doc = Document()..insert(0, '读取文件错误,文件不是Delta格式');
      // quillController = QuillController(
      //     document: doc, selection: const TextSelection.collapsed(offset: 0));
    }
  }

  ///保存笔记
  bool saveNote() {
    var deltaJson = quillController.document.toDelta().toJson();
    print(deltaJson);

    String jsonString = jsonEncode(deltaJson);

    final file = File(noteRouteMsg.noteFilePosition);
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
    String imgDir = noteRouteMsg.noteImgDirPosition!;
    String fileName = CommonTool.getCurrentTime() + ".jpeg";
    var allPath = await FileTool.saveImage(imageBytes, imgDir, fileName);

    print("_onImagePaste:保存路径" + allPath!);
    return allPath;
  }

  /**
   * 插入视频节点
   */
  void insertVideoAnchor(QuillController quillController) {
    Duration currentDuration = videoPlayerController.getCurrentDuration();
    //去除毫秒
    String currentDurationStr = currentDuration.toString().split('.').first;

    insertLinkBlockEmbed(quillController, currentDurationStr, () {
      videoPlayerController.playerSeek(duration: currentDuration);
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

      controller.updateSelection(selection, ChangeSource.remote);

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
    List<QuillToolbarCustomButtonOptions> customQuillCustomButtons = [
      QuillToolbarCustomButtonOptions(
          icon: Icon(Icons.screenshot),
          onPressed: () async {
            insertVideoAnchor(quillController);
            String imgDir = noteRouteMsg.noteImgDirPosition!;

            videoPlayerController.videoScreenShot(imgDir, (absolutePath) {
              insertImageBlockEmbed(absolutePath);
            });
          }),
      QuillToolbarCustomButtonOptions(
          icon: Icon(Icons.flag),
          onPressed: () {
            insertVideoAnchor(quillController);
          }),
      QuillToolbarCustomButtonOptions(
          icon: Icon(Icons.image),
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => InsertImageDialog(),
            );
          }),
      QuillToolbarCustomButtonOptions(
          icon: Icon(Icons.movie_creation), onPressed: () {}),
      QuillToolbarCustomButtonOptions(
          icon: Icon(Icons.photo_camera), onPressed: () {}),
      QuillToolbarCustomButtonOptions(
          icon: Icon(Icons.find_in_page), onPressed: () {}),
      QuillToolbarCustomButtonOptions(icon: Icon(Icons.mic), onPressed: () {}),
      QuillToolbarCustomButtonOptions(
          icon: Icon(Icons.music_note), onPressed: () {}),
      QuillToolbarCustomButtonOptions(
          icon: Icon(Icons.live_tv),
          onPressed: () {
            insertVideoBlockEmbed(
                quillController, "https://file.cccyun.cc/Demo/mv.mp4");
          }),
      QuillToolbarCustomButtonOptions(
          icon: Icon(Icons.unarchive_outlined),
          onPressed: () {
            final msc = Get.find<MultiSplitController>();
            msc.setAxis(Axis.vertical);
          }),
      QuillToolbarCustomButtonOptions(
          icon: Icon(Icons.save),
          onPressed: () {
            bool result = saveNote();
            if (result) {
              SmartDialog.showToast('保存成功');
            } else {
              SmartDialog.showToast('保存失败');
            }
          }),
    ];

    var toolbar = QuillToolbar(
      configurations: QuillToolbarConfigurations(
        customButtons: customQuillCustomButtons,
        showAlignmentButtons: true,
        embedButtons: FlutterQuillEmbeds.toolbarButtons(
          imageButtonOptions: QuillToolbarImageButtonOptions(
            imageButtonConfigurations: QuillToolbarImageConfigurations(
              onImageInsertedCallback: (image) async {
                // _onImagePickCallback(File(image));
              },
              onImageInsertCallback: onImageInsert,
            ),
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
              imageButtonConfigurations: QuillToolbarImageConfigurations(
                onImageInsertedCallback: (image) async {
                  // _onImagePickCallback(File(image));
                },
                onImageInsertCallback: onImageInsert,
              ),
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
              imageButtonConfigurations: QuillToolbarImageConfigurations(
                onImageInsertedCallback: (image) async {
                  // _onImagePickCallback(File(image));
                },
                onImageInsertCallback: onImageInsert,
              ),
            ),
            cameraButtonOptions: QuillToolbarCameraButtonOptions(
              cameraConfigurations: QuillToolbarCameraConfigurations(
                  onVideoInsertedCallback: (source) {
                return Future(() => null);
              }),
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

  /// When inserting an image
  OnImageInsertCallback get onImageInsert {
    return (image, controller) async {
      // final croppedFile = await ImageCropper().cropImage(
      //   sourcePath: image,
      //   aspectRatioPresets: [
      //     CropAspectRatioPreset.square,
      //     CropAspectRatioPreset.ratio3x2,
      //     CropAspectRatioPreset.original,
      //     CropAspectRatioPreset.ratio4x3,
      //     CropAspectRatioPreset.ratio16x9
      //   ],
      //   uiSettings: [
      //     AndroidUiSettings(
      //       toolbarTitle: 'Cropper',
      //       toolbarColor: Colors.deepOrange,
      //       toolbarWidgetColor: Colors.white,
      //       initAspectRatio: CropAspectRatioPreset.original,
      //       lockAspectRatio: false,
      //     ),
      //     IOSUiSettings(
      //       title: 'Cropper',
      //     ),
      //     // WebUiSettings(
      //     //   context: context,
      //     // ),
      //   ],
      // );
      // final newImage = croppedFile?.path;
      // if (newImage == null) {
      //   return;
      // }
      // controller.insertImageBlock(imageSource: newImage);
    };
  }

  /**
   * 构建富文本编辑器
   */
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
        ),
        scrollController: ScrollController(),
        focusNode: _focusNode,
      );
    }

    return quillEditor;
  }

  //获取视频地址或路径
  BaseNote? getBaseNote() {
    Map? arguments = getArguments();
    if (arguments == null) {
      return null;
    }
    BaseNote baseNote = arguments[BaseNote.flag] as BaseNote;

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

  /// 在 widget 内存中分配后立即调用。
  Future<void> onInit() async {
    BaseNote? baseNote = getBaseNote();
    if (baseNote == null) {
      return;
    }
    var baseNoteJson = baseNote.toJson();

    ///持久化保存笔记记录
    await setValue(
        NoteList.noteListPrefix + baseNote.noteRouteMsg.noteFilePosition,
        baseNoteJson);

    print(getStringAsync(
        NoteList.noteListPrefix + baseNote.noteRouteMsg.noteFilePosition));

    state.baseNote = baseNote;
    loadNoteFileData(baseNote.noteRouteMsg.noteFilePosition);
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所

  void onReady() {}

  /// 在 [onDelete] 方法之前调用。
  void onClose() {}

  /// dispose 释放内存
  void dispose() {}
}
