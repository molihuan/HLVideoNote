import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';
import 'widgets/notes_page_widget.dart';
import 'widgets/widgets.dart';

///笔记列表页面
class NotesPage extends GetView<NotesPageController> {
  const NotesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotesPageController>(
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            child: NotesPageWidget(),
          ),
        );
      },
    );
  }
}
