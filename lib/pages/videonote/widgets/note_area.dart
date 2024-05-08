import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:note/pages/videonote/widgets/base_video_note_view.dart';

class NoteArea extends BaseVideoNoteView {
  NoteArea({Key? key}) : super(key: key) {}

  late QuillToolbar quillToolbar;

  Future<void> initData(BuildContext context) async {
    ///构建quillToolbar
    quillToolbar = quillTextController.buildQuillToolbar(context);
  }

  @override
  Widget build(BuildContext context) {
    initData(context);

    return buildQuillView();
  }

  Widget buildQuillView() {
    return  Column(
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
              child: quillTextController.quillEditor,
            ),
          ),
        ],
      );
  }
}
