import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/pages/main/widgets/main_show.dart';

import 'index.dart';

///主要显示区
class MainPage extends GetView<MainController> {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            child: MainShow(),
          ),
        );
      },
    );
  }
}
