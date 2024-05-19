import 'package:flutter/material.dart';
import 'package:videonote/multiwindow/windows_manager.dart';
///笔记窗口
class NoteWindow extends StatelessWidget {
  const NoteWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Text(AppWindows.NoteWindow),
      ),
    );
  }
}