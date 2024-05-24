import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_split_view/multi_split_view.dart';

import '../../../services/editor/flutter_quill_editor/widget.dart';
import '../../../services/editor/flutter_quill_editor/widgets/simple_screen.dart';
import '../../../services/media_display/media_kit_player/widget.dart';
import '../controllers/multi_split_controller.dart';

class VideoNoteWidgetPC extends GetView<MultiSplitController> {
  VideoNoteWidgetPC({Key? key}) : super(key: key);

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
                  SimpleScreen(),
                ])));

    return multiSplitView;
  }
}
