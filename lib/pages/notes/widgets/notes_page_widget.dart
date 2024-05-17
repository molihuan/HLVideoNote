import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../controller.dart';
import 'notes_page_appbar.dart';
import 'notes_page_float_btn.dart';
import 'note_list.dart';

class NotesPageWidget extends GetView<NotesPageController> {
  const NotesPageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NotesPageAppbar(),
      body: NoteList(),
      floatingActionButton: NotesPageFloatBtn(),
    );
  }
}
