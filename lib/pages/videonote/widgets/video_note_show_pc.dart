import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:note/pages/videonote/base_video_note_view.dart';
import 'package:note/pages/videonote/widgets/note_area.dart';
import 'package:note/pages/videonote/widgets/video_area.dart';

class VideoNoteShowPC extends BaseVideoNoteView {
  VideoNoteShowPC({Key? key}) : super(key: key);

  late final multiSplitState = multiSplitController.state;

  late final MultiSplitViewController _multiSplitcontroller =
      multiSplitController.multiSplitViewController;

  @override
  Widget build(BuildContext context) {
    MultiSplitViewTheme multiSplitView = MultiSplitViewTheme(
        data: MultiSplitViewThemeData(
            dividerPainter: DividerPainters.grooved1(
                color: Colors.indigo[100]!,
                highlightedColor: Colors.indigo[900]!)),
        child: Obx(() => MultiSplitView(
                axis: multiSplitState.multiSplitAxis,
                controller: _multiSplitcontroller,
                children: [
                  VideoArea(),
                  NoteArea(),
                ])));

    return multiSplitView;
  }
}
