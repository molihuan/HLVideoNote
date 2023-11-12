// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:note/pages/home/index.dart';
import 'package:note/pages/main/bindings.dart';
import 'package:note/pages/main/view.dart';
import 'package:note/pages/videonote/index.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.Main;

  static final routes = [
    GetPage(
      name: AppRoutes.Main,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.Home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.VideoNote,
      page: () => VideoNotePage(),
      binding: VideoNoteBinding(),
    ),
  ];
}
