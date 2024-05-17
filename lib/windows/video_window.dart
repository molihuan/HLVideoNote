import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:videonote/multiwindow/windows_manager.dart';

import '../common/langs/translation_service.dart';
import '../pages/videonote/bindings.dart';
import '../pages/videonote/widgets/video_area.dart';
import '../routes/app_pages.dart';
///视频窗口
class VideoWindow extends StatelessWidget {
  const VideoWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),

      debugShowCheckedModeBanner: false,
      /// 初始路由
      initialRoute: AppRoutes.VideoArea,
      /// 所有的页面
      getPages: [
        GetPage(
          name: AppRoutes.VideoArea,
          page: () => VideoArea(),
          binding: VideoNoteBinding(),
        )
      ],
      ///国际化
      locale: TranslationService.locale,
      fallbackLocale: TranslationService.fallbackLocale,
      translations: TranslationService(),

      ///flutter_smart_dialog初始化
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
      // 设置nb_util的全局key
      navigatorKey: navigatorKey,
    );
  }
}