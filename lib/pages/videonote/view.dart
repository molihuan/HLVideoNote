import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/pages/videonote/widgets/video_area.dart';

import 'index.dart';

class VideoNotePage extends GetView<VideoNoteController> {
  const VideoNotePage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const VideoArea();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoNoteController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("videonote")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
