import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import 'controller.dart';

class FlutterQuillEditorView extends GetView<FlutterQuillEditorController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildView(),
      ),
    );
  }

  Widget _buildView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        kIsWeb
            ? Expanded(
                child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: controller.quillToolbar,
              ))
            : Container(child: controller.quillToolbar),
        Expanded(
          flex: 15,
          child: Container(
            color: Colors.white,
            // padding: const EdgeInsets.only(left: 5, right: 5),
            child: controller.quillEditor,
          ),
        ),
      ],
    );
  }
}
