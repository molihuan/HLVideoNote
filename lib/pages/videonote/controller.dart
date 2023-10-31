import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:note/pages/videonote/quill_text_controller.dart';
import 'package:note/pages/videonote/video_player_controller.dart';

import 'index.dart';

class VideoNoteController extends GetxController {
  VideoNoteController();

  final state = VideoNoteState();

  //拆分控制器
  late final QuillTextController quillTextController =
      QuillTextController(videoNoteController: this, state: state);

  late final VideoPlayerController videoPlayerController =
      VideoPlayerController(videoNoteController: this, state: state);

  // 创建视频播放器
  late final player = videoPlayerController.player;

  // 创建视频控制器
  late final videoController = videoPlayerController.videoController;

  //创建富文本编辑器
  late final QuillEditor quillEditor = quillTextController.quillEditor;

  //创建富文本控制器
  late final QuillController quillController =
      quillTextController.quillController;

  //传入页面的参数
  Map? getArguments() {
    if (Get.arguments != null) {
      final arguments = Get.arguments as Map;
      return arguments;
    }
    return null;
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

  //视频播放
  void playerOpen(String resource) {
    videoPlayerController.playerOpen(resource);
  }

  /**
   * 调整进度
   */
  Future<void> playerSeek(
      {Duration? duration,
      String? durationStr,
      int day = 0,
      int hour = 0,
      int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0}) async {
    videoPlayerController.playerSeek(
        duration: duration,
        durationStr: durationStr,
        day: day,
        hour: hour,
        minute: minute,
        second: second,
        millisecond: millisecond,
        microsecond: microsecond);
  }

  //获取当前进度
  Duration getCurrentDuration() {
    return videoPlayerController.getCurrentDuration();
  }

  //获取视频地址或路径
  String? getVideoSource() {
    return videoPlayerController.getVideoSource();
  }

  //截屏
  void videoScreenShot(
      String path, void Function(String filePath) callBack) async {
    videoPlayerController.videoScreenShot(path, callBack);
  }

  /**
   * 插入视频锚点
   */
  void insertVideoAnchor(QuillController quillController) {
    quillTextController.insertVideoAnchor(quillController);
  }

  /**
   * 插入图片(本地和网络)
   */
  void insertImageBlockEmbed(String? source) {
    quillTextController.insertImageBlockEmbed(source);
  }

  /**
   * 插入自定义链接
   */
  void insertLinkBlockEmbed(QuillController controller, String text,
      void Function() linkBlockEmbedClick) {
    quillTextController.insertLinkBlockEmbed(
        controller, text, linkBlockEmbedClick);
  }

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    videoPlayerController.onInit();
    quillTextController.onInit();
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所
  @override
  void onReady() {
    videoPlayerController.onReady();
    quillTextController.onReady();
    super.onReady();
  }

  /// 在 [onDelete] 方法之前调用。
  @override
  void onClose() {
    videoPlayerController.onClose();
    quillTextController.onClose();
    super.onClose();
  }

  /// dispose 释放内存
  @override
  void dispose() {
    videoPlayerController.dispose();
    quillTextController.dispose();
    super.dispose();
  }

  QuillToolbar buildQuillToolbar(BuildContext context) {
    return quillTextController.buildQuillToolbar(context);
  }

  QuillEditor buildQuillEditor() {
    return quillTextController.buildQuillEditor();
  }
}
