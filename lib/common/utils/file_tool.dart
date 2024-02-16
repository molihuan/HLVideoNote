import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:external_path/external_path.dart';
import 'package:note/common/utils/common_tool.dart';
import 'package:note/common/utils/platform_tool.dart';
import 'package:note/models/note/base_note.dart';
import 'package:note/models/note/note_route_msg.dart';
import 'package:note/models/r_source.dart';
import 'package:note/models/read_media.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';

class FileTool {
  static const String DIR_DEFAULT_NOTE_PROJECT = "NoteProject";

  static bool deleteFiles(String folderPath) {
    Directory folder = Directory(folderPath);
    if (folder.existsSync()) {
      folder.deleteSync(recursive: true);
      return true;
    } else {
      print('文件夹不存在');
      return false;
    }
  }

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
    File imageFile = File(absolutePath);

    try {
      /// 将图片数据写入文件
      await imageFile.writeAsBytes(imageBytes);

      /// 返回保存的图片路径
      return absolutePath;
    } catch (e) {
      print('保存图片出错：$e');
      return null;
    }
  }

  ///获取外部存储路径
  ///仅仅适应Android
  // static Future<String?> getExternalStoragePath() async {
  //   String directoryPath;
  //   try {
  //     final directory = await getExternalStorageDirectory();
  //     directoryPath = directory!.path;
  //   } catch (e) {
  //     print('Failed to get external storage directory: $e');
  //     return null;
  //   }
  //   return directoryPath;
  // }

  // static String getProjectRootPath() {
  //   String projectPath = '';
  //   try {
  //     projectPath = path.current;
  //   } catch (e) {
  //     print('Failed to get project root path: $e');
  //   }
  //   return projectPath;
  // }

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

  /// 将字符串写入文件
  static bool writeString(String filePath, contents) {
    final file = File(filePath);
    try {
      file.writeAsStringSync(contents);
      return true;
    } catch (e) {
      print('writeString err: $e');
      return false;
    }
  }

  /// 将json覆盖式写入文件
  /// 内容优先[jsonContent],[jsonContent]和[mapContent]不能同时为null
  static bool writeJson(String filePath,
      {Map? mapContent, String? jsonContent}) {
    final file = File(filePath);
    try {
      jsonContent ??= jsonEncode(mapContent!);
      file.writeAsStringSync(jsonContent);
      return true;
    } catch (e) {
      print('writeJson err: $e');
      return false;
    }
  }

  /// 把文件转换为json
  static Map? readJson(String filePath) {
    final file = File(filePath);
    try {
      var jsonString = file.readAsStringSync();
      Map jsonObj = jsonDecode(jsonString);
      return jsonObj;
    } catch (e) {
      print('readJson err: $e');
      return null;
    }
  }

  static Future<String> getAppName() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.appName;
  }

  ///获取默认的笔记保存路径
  static Future<String> getDefaultNoteSavePath() {
    return PlatformTool.callback<Future<String>, FStrCallback>(
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

  /// 创建笔记项目
  static Future<String?> createNoteProjectFile(
      BaseNote baseNote, String readMedia) async {
    var noteRouteMsg = baseNote.noteRouteMsg;

    //TODO 判断权限是否足够

    //判断指定文件是否存在
    if (fileExists(noteRouteMsg.noteFilePosition)) {
      return noteRouteMsg.noteFilePosition;
    }

    //资源分类
    List<String> resourceClass = [
      noteRouteMsg.noteImgDirPosition!,
      noteRouteMsg.noteConfigDirPosition!,
      noteRouteMsg.noteVideoDirPosition!,
      noteRouteMsg.notePdfDirPosition!,
    ];

    for (String dir in resourceClass) {
      Directory(dir).createSync(recursive: true);
      if (dir == NotePositionConstant.dirConfig.v) {}
    }

    ///设置阅读媒介的类型，本地、网络
    ///设置阅读媒介
    Map<String, String> content = {
      ReadMedia.flag + Rsource.flag: SourceType.LOCAL.name,
      ReadMedia.flag: readMedia,
    };
    writeJson(noteRouteMsg.noteBaseConfigFilePosition!, mapContent: content);

    bool createResult =
        createFile(noteRouteMsg.noteFilePosition, context: '[{"insert":" "}]');
    if (createResult) {
      return noteRouteMsg.noteFilePosition;
    }

    return null;
  }

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
