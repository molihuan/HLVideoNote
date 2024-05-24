// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:videonote/pages/user/index.dart';

import 'main/bindings.dart';
import 'main/view.dart';
import 'notes/bindings.dart';
import 'notes/view.dart';
import 'user/bindings.dart';

import 'videonote/bindings/multi_split_binding.dart';
import 'videonote/view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.MainPage;

  static final routes = [
    ///主显示页面
    GetPage(
      name: AppRoutes.MainPage,
      page: () => const MainPage(),
      bindings: [
        MainPageBinding(),
      ],
      arguments: {"args1": "1"},
    ),

    ///视频笔记列表页面
    // GetPage(
    //   name: AppRoutes.NotesPage,
    //   page: () => const NotesPage(),
    //   binding: NotesPageBinding(),
    // ),

    /// 用户页面
    // GetPage(
    //   name: AppRoutes.UserPage,
    //   page: () => const UserPage(),
    //   binding: UserPageBinding(),
    // ),

    /// 视频笔记页面
    GetPage(
      name: AppRoutes.VideoNotePage,
      page: () => VideoNotePage(),
      bindings: [
        MultiSplitBinding(),
      ],
    ),
  ];
}
