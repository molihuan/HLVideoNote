import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:media_kit/media_kit.dart';
import 'package:note/common/langs/translation_service.dart';

import 'common/routes/app_pages.dart';

Future<void> main() async {
  // 初始化 GetX
  WidgetsFlutterBinding.ensureInitialized();
  // Necessary initialization for package:media_kit.
  MediaKit.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: Colors.orange,
      ),

      debugShowCheckedModeBanner: false,
      // 初始路由
      initialRoute: AppPages.INITIAL,
      // 所有的页面
      getPages: AppPages.routes,
      //国际化
      locale: TranslationService.locale,
      fallbackLocale: TranslationService.fallbackLocale,
      translations: TranslationService(),
    );
  }
}
