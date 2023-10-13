import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/common/utils/platform_tool.dart';
import 'package:note/pages/videonote/widgets/base_video_note_show.dart';
import 'package:note/pages/videonote/widgets/video_note_show_phone.dart';
import 'package:note/pages/videonote/widgets/video_note_show_pc.dart';

import 'index.dart';

class VideoNotePage extends GetView<VideoNoteController> {
  const VideoNotePage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    // return VideoNoteShowPhone();

    switch (PlatformTool.getCurrentPlatform()) {
      case RunningPlatform.android:
      case RunningPlatform.ios:
        return VideoNoteShowPhone();
      case RunningPlatform.linux:
      case RunningPlatform.macos:
      case RunningPlatform.windows:
        return VideoNoteShowPC();
      case RunningPlatform.web:
        return VideoNoteShowPC();
      default:
        return VideoNoteShowPC();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoNoteController>(
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
