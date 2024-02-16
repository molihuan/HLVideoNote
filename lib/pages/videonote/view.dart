import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/common/utils/common_tool.dart';
import 'package:note/common/utils/platform_tool.dart';
import 'package:note/pages/videonote/widgets/video_note_show_pc.dart';
import 'package:note/pages/videonote/widgets/video_note_show_phone.dart';

import 'controller/quill_text_controller.dart';

class VideoNotePage extends GetView {
  const VideoNotePage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return PlatformTool.callback<Widget, WgetCallback>(android: () {
      return VideoNoteShowPhone();
    }, ios: () {
      return VideoNoteShowPhone();
    }, other: () {
      return VideoNoteShowPC();
    })!;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuillTextController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
