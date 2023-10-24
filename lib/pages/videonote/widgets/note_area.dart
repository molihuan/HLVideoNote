import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:note/pages/videonote/index.dart';

class NoteArea extends GetView<VideoNoteController> {
  NoteArea({Key? key}) : super(key: key);

  final controller = Get.find<VideoNoteController>();
  late final quillController = controller.quillController;
  late final quillEditor = controller.quillEditor;
  late final quillToolbar;

  @override
  Widget build(BuildContext context) {
    initData(context);
    return buildQuillView();
  }

  void initData(BuildContext context) {
    quillToolbar = controller.buildQuillToolbar(context);
  }

  Widget buildQuillView() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          kIsWeb
              ? Expanded(
                  child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: quillToolbar,
                ))
              : Container(child: quillToolbar),
          Expanded(
            flex: 15,
            child: Container(
              color: Colors.white,
              // padding: const EdgeInsets.only(left: 5, right: 5),
              child: quillEditor,
            ),
          ),
        ],
      ),
    );
  }
}
