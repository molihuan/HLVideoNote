import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:note/pages/videonote/base_video_note_view.dart';
import 'package:note/pages/videonote/widgets/note_area.dart';
import 'package:note/pages/videonote/widgets/video_area.dart';

class VideoNoteShowPhone extends BaseVideoNoteView {
  VideoNoteShowPhone({Key? key}) : super(key: key);

  late var controller = super.controller;

  @override
  Widget build(BuildContext context) {
    return MultiSplitView(
        axis: Axis.vertical, children: [VideoArea(), NoteArea()]);
  }
}
