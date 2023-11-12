import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:note/pages/videonote/base_video_note_view.dart';

class NoteArea extends BaseVideoNoteView {
  NoteArea({Key? key}) : super(key: key);

  late final quillController = quillTextController.quillController;
  late final quillEditor = quillTextController.quillEditor;
  late final quillToolbar;

  @override
  Widget build(BuildContext context) {
    initData(context);
    return buildQuillView();
  }

  void initData(BuildContext context) {
    quillToolbar = quillTextController.buildQuillToolbar(context);
  }

  Widget buildQuillView() {
    return QuillProvider(
      configurations: QuillConfigurations(
        controller: quillController,
        sharedConfigurations: const QuillSharedConfigurations(
            // locale: Locale('zh'),
            ),
      ),
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
