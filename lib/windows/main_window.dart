import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:nb_utils/nb_utils.dart';

import '../common/langs/translation_service.dart';
import '../routes/app_pages.dart';
///主窗口
class MainWindow extends StatelessWidget {
  const MainWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),

      debugShowCheckedModeBanner: false,
      /// 初始路由
      initialRoute: AppPages.INITIAL,
      /// 所有的页面
      getPages: AppPages.routes,
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