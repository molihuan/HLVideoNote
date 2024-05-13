import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:multi_split_view/multi_split_view.dart';

import 'base_video_note_view.dart';
import 'note_area.dart';
import 'video_area.dart';


class VideoNoteShowPhone extends BaseVideoNoteView {
  VideoNoteShowPhone({Key? key}) : super(key: key);

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
