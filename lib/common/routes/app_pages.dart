// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:note/pages/main/bindings.dart';
import 'package:note/pages/main/view.dart';
import 'package:note/pages/videonote/index.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.Home;

  static final routes = [
    GetPage(
      name: AppRoutes.Home,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.VideoNote,
      page: () => const VideoNotePage(),
      binding: VideoNoteBinding(),
    ),
  ];
}
