import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:note/pages/home/controller.dart';
import 'package:note/pages/home/widgets/home_appbar.dart';
import 'package:note/pages/home/widgets/home_float_btn.dart';
import 'package:note/pages/home/widgets/note_list.dart';

class HomeShow extends GetView<HomeController> {
  const HomeShow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppbar(),
      body: NoteList(),
      floatingActionButton: HomeFloatBtn(),
    );
  }
}
