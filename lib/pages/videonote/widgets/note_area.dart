import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'base_video_note_view.dart';


class NoteArea extends BaseVideoNoteView {
  NoteArea({Key? key}) : super(key: key) {}


  @override
  Widget build(BuildContext context) {
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
            child: quillTextController.quillEditor,
          ),
        ),
      ],
    );
  }
}
