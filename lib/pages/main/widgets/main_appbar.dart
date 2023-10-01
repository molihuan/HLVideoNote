import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:note/common/utils/permission_tool.dart';
import 'package:note/pages/main/controller.dart';

class MainAppbar extends AppBar {
  @override
  _MainAppbarState createState() => _MainAppbarState();
}

class _MainAppbarState extends State<MainAppbar> {
  final controller = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return GFAppBar(
      searchBar: true,
      actions: [
        PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Text('sort'.tr),
            ),
            PopupMenuItem(
              child: Text('language'.tr),
              onTap: () => {
                PermissionTool.requestStoragePermission()

                // PopupMenuButton(
                //   itemBuilder: (context) => [
                //     PopupMenuItem(
                //       child: Text('zh_CN'.tr),
                //       onTap: () {
                //         var locale = Locale('zh', 'CN');
                //         Get.updateLocale(locale);
                //       },
                //     ),
                //     PopupMenuItem(
                //       child: Text('zh_HK'.tr),
                //       onTap: () {
                //         var locale = Locale('zh', 'HK');
                //         Get.updateLocale(locale);
                //       },
                //     ),
                //     PopupMenuItem(
                //       child: Text('en_US'.tr),
                //       onTap: () {
                //         var locale = Locale('en', 'US');
                //         Get.updateLocale(locale);
                //       },
                //     ),
                //   ],
                // )
              },
            ),
          ],
        ),
      ],
    );
  }
}
