import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:videonote/models/note_model/base_note.dart';
import 'package:videonote/multiwindow/app_windows_manager.dart';

import '../../common/langs/translation_service.dart';
import '../../pages/app_pages.dart';
import '../../services/media_display/media_kit_player/widget.dart';

///视频窗口
class VideoWindow extends StatelessWidget {
  VideoWindow(
      {required this.windowController, required this.baseNote, Key? key})
      : super(key: key);

  WindowController windowController;
  BaseNote baseNote;

  Widget _build() {
    /// 其他窗口向此窗口发送消息可以在这里获取
    AppWindowsManager.receiveWindowDataCallback(
        AppWindows.MainWindow, (fromId, data) {},
        windowController: windowController);

    return Column(
      children: [
        Row(children: [
          ElevatedButton(
              onPressed: () {
                windowController.close();
              },
              child: Text("关闭")),
          ElevatedButton(
              onPressed: () {
                AppWindowsManager.sendDataToMainWindow(
                    AppWindows.VideoWindow, "data2");
              },
              child: Text("向主页面发消息")),
        ]),
        Expanded(child: MediaKitPlayerView()),
      ],
    );
  }

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
          page: _build,
          arguments: {
            BaseNote.flag: baseNote,
          },
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
