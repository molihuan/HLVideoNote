import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:common_utils/common_utils.dart';
import 'package:external_path/external_path.dart';


import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';
import 'package:videonote/common/utils/str_tool.dart';

import '../../models/note_model/base_note.dart';
import 'common_tool.dart';
import 'platform_tool.dart';

class FileTool {
  static const String DIR_DEFAULT_NOTE_PROJECT = "NoteProject";

  static loadNoteFile(){

  }

  static bool deleteAll(String path) {
    Directory folder = Directory(path);
    if (folder.existsSync()) {
      folder.deleteSync(recursive: true);
      return true;
    } else {
      LogUtil.d('文件夹不存在');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> readJsonFile(String filePath) async {
    try {
      // 读取文件内容
      File file = File(filePath);
      String content = await file.readAsString();

      // 将文件内容解析为 JSON
      Map<String, dynamic>? jsonData = json.decode(content);
      return jsonData;
    } catch (error) {
      LogUtil.e('读取文件时出现错误：$error');
      return null;
    }
  }
  ///读取文件内容
   static String? readFile(String filePath){
    try {
      // 读取文件内容
      File file = File(filePath);
      String content = file.readAsStringSync();
      return content;
    } catch (error) {
      return null;
    }
  }

  static Future<bool> writeFile(String filePath, String content) async {
    try {
      // 创建文件
      File file = File(filePath);
      // 写入内容
      await file.writeAsString(content);
      return true;
    } catch (error) {
      return false;
    }
  }

  static Future<bool> writeMapToFile(String filePath, Map<String, dynamic> map) async {
    try {
      // 将 Map 转换为 JSON 格式的字符串
      String jsonString = jsonEncode(map);

      // 创建文件
      File file = File(filePath);

      // 写入内容
      await file.writeAsString(jsonString);

      LogUtil.d('文件创建成功并写入内容。');
      return true;
    } catch (error) {
      LogUtil.e('写入文件时出现错误：$error');
      return false;
    }
  }

///////////////////////////////////////////////////////////////////////////

  ///保存图片
  ///[imageBytes] 图片数据
  ///[dirPath] 保存路径
  ///[fileName] 文件名称，如1.jpg
  static Future<String?> saveImage(
      Uint8List imageBytes, String dirPath, String fileName) async {
    // 获取图片保存目录
    Directory directory = Directory(dirPath);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    String absolutePath = join(dirPath, fileName);
    /// 处理windows路径
    absolutePath = StrTool.handleWinPos(absolutePath)!;

    File imageFile = File(absolutePath);

    try {
      /// 将图片数据写入文件
      await imageFile.writeAsBytes(imageBytes);
      /// 返回保存的图片路径
      return absolutePath;
    } catch (e) {
      print('保存图片出错:$e');
      return null;
    }
  }


  ///获取当前可执行文件路径
  static String? getCurrentAppPath() {
    try {
      return path.dirname(Platform.resolvedExecutable);
    } catch (e) {
      print('Failed to get current app path: $e');
      return null;
    }
  }

  /// 判断文件夹是否存在
  static bool dirExists(String path) {
    Directory directory = Directory(path);
    if (directory.existsSync()) {
      return true;
    }
    return false;
  }

  /// 判断文件是否存在
  static bool fileExists(String path) {
    File file = File(path);
    if (file.existsSync()) {
      return true;
    }
    return false;
  }


  static Future<String> getAppName() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.appName;
  }

  ///获取默认的笔记保存路径
  static Future<String> getDefaultNoteSavePath() {
    return PlatformTool.callback<Future<String>, StrFcallback>(
        android: () async {
      String docPath = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOCUMENTS);

      String targetPath =
          join(docPath, await getAppName(), DIR_DEFAULT_NOTE_PROJECT);
      print("默认笔记保存路径:$targetPath");
      return targetPath;
    }, ios: () async {
      return "";
    }, other: () async {
      var appPath = getCurrentAppPath();
      if (appPath == null) {
        return "";
      }
      var dPath = join(appPath, DIR_DEFAULT_NOTE_PROJECT);
      return dPath;
    })!;
  }

  /**
   * 创建笔记项目文件
   * 保存路径
   * 笔记名称
   * 视频路径或网址
   * 目录结构:
   * --noteName1
   *   --noteName1.hl
   *   --resource
   *     --img(存放图片、截图)
   *     --config(是什么模式的笔记，存放白板数据)
   *     --video(存放视频)
   *     --pdf(存放pdf)
   */


  ///获取上一级路径
  static String? getParentPath(String path) {
    if (path.isEmpty) {
      return null;
    }

    ///如果是以路径分隔符结尾则去除最后的路径分隔符
    if (path.endsWith(Platform.pathSeparator)) {
      path = path.substring(0, path.length - 1);
    }

    if (!path.contains(Platform.pathSeparator)) {
      return null;
    }
    int endIndex = path.lastIndexOf(Platform.pathSeparator);
    return path.substring(0, endIndex);
  }

  /// 创建文件
  static bool createFile(String filePath, {String? context}) {
    File file = File(filePath);
    try {
      if (context == null) {
        file.createSync(recursive: true); // 创建文件
      } else {
        file.writeAsStringSync(context);
      }

      if (file.existsSync()) {
        // 检查文件是否存在
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('文件创建失败: $e');
      return false;
    }
  }
}
