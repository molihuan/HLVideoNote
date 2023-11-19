import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:note/pages/main/controller.dart';

class HomeAppbar extends AppBar {
  @override
  _HomeAppbarState createState() => _HomeAppbarState();
}

class _HomeAppbarState extends State<HomeAppbar> {
  final controller = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return GFAppBar(
      searchBar: true,
      leading: IconButton(
        icon: GFAvatar(
          backgroundImage: AssetImage('assets/images/ml.png'),
          backgroundColor: Colors.transparent,
        ),
        onPressed: () {
          GFToast.showToast("666", context);
        },
      ),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Text('sort'.tr),
              onTap: () {},
            ),
            PopupMenuItem(
              child: Text("显示模式"),
              onTap: () {},
            ),
            PopupMenuItem(
              child: Text('language'.tr),
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}
