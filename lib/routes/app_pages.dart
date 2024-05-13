// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';

import '../pages/home/bindings.dart';
import '../pages/home/view.dart';
import '../pages/main/bindings.dart';
import '../pages/main/view.dart';
import '../pages/videonote/bindings.dart';
import '../pages/videonote/view.dart';


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
