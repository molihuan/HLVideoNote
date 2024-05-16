import 'package:videonote/common/utils/platform_tool.dart';

import 'common_tool.dart';

class StrTool {
  ///处理win路径
  static String? handleWinPos(String pos) {
    return PlatformTool.callback<String,StrCallback>(windows: (){
      return pos.replaceAll("\\", "/");
    }, other: (){
      return pos;
    });
  }
}