import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/utils/common_tool.dart';
import '../../common/utils/platform_tool.dart';

import 'widgets/video_note_widget_pc.dart';
import 'widgets/video_note_widget_phone.dart';

///视频笔记页面
class VideoNotePage extends GetView {
  const VideoNotePage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return PlatformTool.callbackPhonePC<Widget, WgetCallback>(phone: () {
      return VideoNoteWidgetPhone();
    }, pc: () {
      return VideoNoteWidgetPC();
    })!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildView(),
      ),
    );
  }
}
