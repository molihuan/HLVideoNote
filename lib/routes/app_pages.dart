// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:videonote/pages/user/index.dart';

import '../pages/main/bindings.dart';
import '../pages/main/view.dart';
import '../pages/notes/bindings.dart';
import '../pages/notes/view.dart';
import '../pages/user/bindings.dart';
import '../pages/videonote/bindings.dart';
import '../pages/videonote/view.dart';
import '../pages/videonote/widgets/note_area.dart';
import '../pages/videonote/widgets/video_area.dart';

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
      binding: VideoNoteBinding(),
    ),
  ];
}
