import 'dart:convert';
import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:note/common/utils/common_tool.dart';
import 'package:note/common/utils/platform_tool.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

enum FileSourceType { LOCAL, NETWORK }

class FileTool {
  static const String FILE_NAME_IMG = "img";
  static const String FILE_NAME_CONFIG = "config";
  static const String FILE_NAME_VIDEO = "video";
  static const String FILE_NAME_PDF = "pdf";
  static const String FILE_NAME_RESOURCE = "resource";
  static const String FILE_NAME_SUFFIX_HL = ".hl";
  static const String VIDEO_SOURCE_KEY = "videoSource";
  static const String FILE_NAME_BASE_CONFIG_JSON = "BaseConfig.json";

  ///获取外部存储路径
  static Future<String> getExternalStoragePath() async {
    String directoryPath = '';
    try {
      final directory = await getExternalStorageDirectory();
      directoryPath = directory!.path;
    } catch (e) {
      print('Failed to get external storage directory: $e');
    }
    print(directoryPath);
    return directoryPath;
  }

  /**
   * 判断文件夹是否存在
   */
  static bool dirExists(String path) {
    Directory directory = Directory(path);
    if (directory.existsSync()) {
      return true;
    }
    return false;
  }

  /**
   * 判断文件是否存在
   */
  static bool fileExists(String path) {
    File file = File(path);
    if (file.existsSync()) {
      return true;
    }
    return false;
  }

  /**
   * 将字符串写入文件
   */
  static bool writeString(String filePath, contents) {
    final file = File(filePath);
    try {
      file.writeAsStringSync(contents);
      return true;
    } catch (e) {
      print('文件写入失败: $e');
      return false;
    }
  }

  /**
   * 将json覆盖式写入文件
   */
  static bool writeJson(String filePath, dynamic strContent) {
    final file = File(filePath);
    try {
      final jsonString = jsonEncode(strContent);
      file.writeAsStringSync(jsonString);
      return true;
    } catch (e) {
      print('文件写入失败: $e');
      return false;
    }
  }

  /**
   * 把文件转换为json
   */
  static Map? readJson(String filePath) {
    final file = File(filePath);
    try {
      var jsonString = file.readAsStringSync();
      Map jsonObj = jsonDecode(jsonString);
      return jsonObj;
    } catch (e) {
      print('失败: $e');
      return null;
    }
  }

  static String getCurrentAppPath() {
    String appPath = '';
    try {
      appPath = path.dirname(Platform.resolvedExecutable);
    } catch (e) {
      print('Failed to get current app path: $e');
    }
    return appPath;
  }

  static String getProjectRootPath() {
    String projectPath = '';
    try {
      projectPath = path.current;
    } catch (e) {
      print('Failed to get project root path: $e');
    }
    return projectPath;
  }

  static Future<String> getAppName() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.appName;
  }

  static Future<String> getDefaultNoteSavePath() {
    return PlatformTool.callback<Future<String>, FStrCallback>(
        android: () async {
      String docPath = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOCUMENTS);

      String targetPath = docPath + Platform.pathSeparator + await getAppName();
      print(targetPath);
      return targetPath;
    }, windows: () {
      var projectRootPath = getProjectRootPath();
      return Future.value(projectRootPath);
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
  static Future<String?> createNoteProjectFile(
      String noteSavePath, String noteNameNoSuffix, String videoSource) async {
    if (noteSavePath.isEmpty) {
      noteSavePath = await getDefaultNoteSavePath();
    }

    //TODO 判断权限是否足够
    //获取项目目录
    String noteProjectPath =
        noteSavePath + Platform.pathSeparator + noteNameNoSuffix;
    //获取笔记文件路径
    String noteFilePath = noteProjectPath +
        Platform.pathSeparator +
        noteNameNoSuffix +
        FILE_NAME_SUFFIX_HL;
    //判断指定文件是否存在
    if (fileExists(noteFilePath)) {
      return noteFilePath;
    }
    //获取笔记资源路径
    String noteResourcePath = noteProjectPath +
        Platform.pathSeparator +
        FILE_NAME_RESOURCE +
        Platform.pathSeparator;
    //资源分类
    List<String> resourceClass = [
      FILE_NAME_IMG,
      FILE_NAME_CONFIG,
      FILE_NAME_VIDEO,
      FILE_NAME_PDF
    ];

    for (String item in resourceClass) {
      String itemPath = noteResourcePath + item;
      Directory(itemPath).createSync(recursive: true);
      if (item == FILE_NAME_CONFIG) {
        Map<String, dynamic> content = {
          VIDEO_SOURCE_KEY: videoSource,
        };
        String baseConfigPath =
            itemPath + Platform.pathSeparator + FILE_NAME_BASE_CONFIG_JSON;
        writeJson(baseConfigPath, content);
      }
    }

    bool createResult = createFile(noteFilePath, context: '[{"insert":"\n"}]');
    if (createResult) {
      return noteFilePath;
    }

    return null;
  }

  /**
   * 获取上一级目录
   */
  static String getParentPath(String path) {
    int endIndex = path.lastIndexOf(Platform.pathSeparator);
    return path.substring(0, endIndex);
  }

  /**
   * 创建文件
   */
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
