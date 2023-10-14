import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_quill_extensions/shims/dart_ui_real.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:note/common/utils/common_tool.dart';
import 'package:note/pages/videonote/widgets/link_blockembed.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'index.dart';

class VideoNoteController extends GetxController {
  VideoNoteController();

  final state = VideoNoteState();

  // 创建视频播放器
  late final player = Player(
    configuration: PlayerConfiguration(
      // Supply your options:
      title: 'My awesome package:media_kit application',
      ready: () {
        print('The initialization is complete.');
      },
    ),
  );
  // 创建视频控制器
  late final videoController = VideoController(player);

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
  late final QuillController quillController = QuillController.basic();

  final FocusNode _focusNode = FocusNode();

  late final QuillToolbar quillToolbar = buildQuillToolbar();

  //
  void playerOpen(String resource) {
    player.open(Media(resource));
  }

  //页面调整
  RxDouble _dividerPosition = 0.5.obs;
  set dividerPosition(value) => _dividerPosition.value = value;
  get dividerPosition => _dividerPosition.value;

  double minPosition = 0.25;
  double maxPosition = 0.75;

  void updateDividerPosition(double delta) {
    _dividerPosition.value += delta;
    if (_dividerPosition.value < minPosition) {
      _dividerPosition.value = minPosition;
    } else if (_dividerPosition.value > maxPosition) {
      _dividerPosition.value = maxPosition;
    }
  }

  //end页面调整
  /**
   * 初始化播放器设置
   */
  Future<void> initPlayerSetting() async {
    await player.setPlaylistMode(PlaylistMode.single);
    playerlisten();
  }

  /**
   * 调整进度
   */
  Future<void> playerSeek(
      {Duration? duration,
      int day = 0,
      int hour = 0,
      int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0}) async {
    await player.seek(
      duration ??
          Duration(
              days: day,
              hours: hour,
              minutes: minute,
              seconds: second,
              milliseconds: millisecond,
              microseconds: microsecond),
    );
  }

  void playerlisten() {
    player.stream.position.listen(
      (Duration position) {
        state.currentDuration = position;
      },
    );
  }

  //获取当前进度
  Duration getCurrentDuration() {
    return state.currentDuration;
  }

  //获取视频地址或路径
  String? getVideoSource() {
    if (Get.arguments != null) {
      final arguments = Get.arguments as Map;
      return arguments['videoSource'] as String;
    }
    return null;
  }

  //截屏
  void videoScreenShot(
      String path, void Function(String filePath) callBack) async {
    final Uint8List? screenshotData =
        await player.screenshot(format: "image/jpeg");
    final String fileName = CommonTool.getCurrentTime() + ".jpeg";
    print("截屏文件名:${fileName}");
    var result = CommonTool.saveImage(screenshotData, path, fileName);
    result.then((absolutePath) => {
          if (absolutePath != null)
            {
              // GFToast.showToast(
              //   '保存在:${fileName}',
              //   context,
              //   textStyle: TextStyle(fontSize: 16, color: Colors.black54),
              //   backgroundColor: Colors.white,
              // )
              callBack(absolutePath)
            }
          else
            {
              // GFToast.showToast(
              //   '保存失败',
              //   context,
              //   textStyle: TextStyle(fontSize: 16, color: Colors.black54),
              //   backgroundColor: Colors.white,
              // )
            }
        });
  }

  /**
   * 插入视频锚点
   */
  void insertVideoAnchor(QuillController quillController) {
    Duration currentDuration = getCurrentDuration();
    //去除毫秒
    String currentDurationStr = currentDuration.toString().split('.').first;

    insertLinkBlockEmbed(quillController, currentDurationStr, () {
      playerSeek(duration: currentDuration);
    });
  }

  /**
   * 插入图片
   */
  void insertImageBlockEmbed(QuillController controller, String? value) {
    if (value != null && value.isNotEmpty) {
      final index = controller.selection.baseOffset;
      final length = controller.selection.extentOffset - index;
      controller.replaceText(index, length, BlockEmbed.image(value), null);
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

  void initQuillModule() {}

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    initPlayerSetting();
    initQuillModule();

    var videoSource = getVideoSource();

    if (videoSource != null) {
      playerOpen(videoSource);
    }
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所
  @override
  void onReady() {
    super.onReady();
  }

  /// 在 [onDelete] 方法之前调用。
  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }

  /// dispose 释放内存
  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  bool _isDesktop() => !kIsWeb && !Platform.isAndroid && !Platform.isIOS;

  QuillToolbar buildQuillToolbar() {
    List<QuillCustomButton> customQuillCustomButtons = [
      QuillCustomButton(
          icon: Icons.screenshot,
          onTap: () async {
            insertVideoAnchor(quillController);
            final Directory appDocumentsDir =
                await getApplicationDocumentsDirectory();
            print("截图保存路径为" + appDocumentsDir.path);

            videoScreenShot(appDocumentsDir.path, (absolutePath) {
              insertImageBlockEmbed(quillController, absolutePath);
            });
          }),
      QuillCustomButton(
          icon: Icons.flag,
          onTap: () {
            insertVideoAnchor(quillController);
          }),
      QuillCustomButton(icon: Icons.find_in_page, onTap: () {}),
      QuillCustomButton(icon: Icons.mic, onTap: () {}),
      QuillCustomButton(icon: Icons.music_note, onTap: () {}),
      QuillCustomButton(icon: Icons.live_tv, onTap: () {}),
      QuillCustomButton(icon: Icons.save, onTap: () {}),
    ];

    var toolbar = QuillToolbar.basic(
        controller: quillController!,
        embedButtons: FlutterQuillEmbeds.buttons(
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
              // onImagePickCallback: _onImagePickCallback,
              // filePickImpl: openFileSystemPickerForDesktop,
              ),
          showAlignmentButtons: true,
          afterButtonPressed: _focusNode.requestFocus,
          customButtons: customQuillCustomButtons);
    }
    return toolbar;
  }

  Future<String> _onImagePaste(Uint8List imageBytes) async {
    // Saves the image to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final file = await File(
            '${appDocDir.path}/${basename('${DateTime.now().millisecondsSinceEpoch}.png')}')
        .writeAsBytes(imageBytes, flush: true);
    return file.path.toString();
  }

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
      // onTapUp: (details, p1) {
      //   return _onTripleClickSelection();
      // },
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
          placeholder: 'Add content',
          expands: false,
          padding: EdgeInsets.zero,
          // onTapUp: (details, p1) {
          //   return _onTripleClickSelection();
          // },
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
}
