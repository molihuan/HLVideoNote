import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_split_view/multi_split_view.dart';

import 'base_video_note_widget.dart';
import 'note_area.dart';
import 'video_area.dart';

class VideoNoteWidgetPC extends BaseVideoNoteWidget {
  VideoNoteWidgetPC({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MultiSplitViewTheme multiSplitView = MultiSplitViewTheme(
        data: MultiSplitViewThemeData(
            dividerPainter: DividerPainters.grooved1(
                color: Colors.indigo[100]!,
                highlightedColor: Colors.indigo[900]!)),
        child: Obx(() => MultiSplitView(
                axis: multiSplitController.state.multiSplitAxis,
                controller: multiSplitController.multiSplitViewController,
                children: [
                  VideoArea(),
                  NoteArea(),
                ])));

    return multiSplitView;
  }
}
