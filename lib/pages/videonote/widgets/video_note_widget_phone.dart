import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:multi_split_view/multi_split_view.dart';

import '../../../services/editor/flutter_quill_editor/widget.dart';
import '../../../services/media_display/media_kit_player/widget.dart';
import '../controllers/multi_split_controller.dart';

class VideoNoteWidgetPhone extends GetView<MultiSplitController> {
  VideoNoteWidgetPhone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MultiSplitViewTheme multiSplitView = MultiSplitViewTheme(
        data: MultiSplitViewThemeData(
            dividerPainter: DividerPainters.grooved1(
                color: Colors.indigo[100]!,
                highlightedColor: Colors.indigo[900]!)),
        child: Obx(() => MultiSplitView(
                axis: controller.state.multiSplitAxis,
                controller: controller.multiSplitViewController,
                children: [
                  MediaKitPlayerView(),
                  FlutterQuillEditorView(),
                ])));

    return multiSplitView;
  }
}
