import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../controller.dart';
import 'home_appbar.dart';
import 'home_float_btn.dart';
import 'note_list.dart';


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
