import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:note/pages/videonote/index.dart';

class VideoArea extends StatefulWidget {
  const VideoArea({Key? key}) : super(key: key);

  @override
  _VideoAreaState createState() => _VideoAreaState();
}

class _VideoAreaState extends State<VideoArea> {
  final controller = Get.find<VideoNoteController>();

  // Create a [Player] to control playback.
  late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final videoController = VideoController(player);

  @override
  void initState() {
    super.initState();
    // Play a [Media] or [Playlist].
    player.open(Media(
        'https://pan.tenire.com/view.php/4a52d164cbad0665eb133dc1a9462256.mp4'));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 9.0 / 16.0,
        // Use [Video] widget to display video output.
        child: Video(controller: videoController),
      ),
    );
  }
}
