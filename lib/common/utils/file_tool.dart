import 'dart:convert';
import 'dart:io';

enum FileSourceType { LOCAL, NETWORK }

class FileTool {
  static String FILE_NAME_IMG = "img";
  static String FILE_NAME_CONFIG = "config";
  static String FILE_NAME_VIDEO = "video";
  static String FILE_NAME_PDF = "pdf";
  static String FILE_NAME_RESOURCE = "resource";
  static String FILE_NAME_SUFFIX_HL = ".hl";

  static bool dirExists(String path) {
    Directory directory = Directory(path);
    if (directory.existsSync()) {
      return true;
    }
    return false;
  }

  static bool fileExists(String path) {
    File file = File(path);
    if (file.existsSync()) {
      return true;
    }
    return false;
  }

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

  static String? createNoteProjectFile(
      String noteSavePath, String noteNameNoSuffix, String videoSource) {
    //TODO 判断权限是否足够
    String noteProjectPath =
        noteSavePath + Platform.pathSeparator + noteNameNoSuffix;

    String noteFilePath = noteProjectPath +
        Platform.pathSeparator +
        noteNameNoSuffix +
        FILE_NAME_SUFFIX_HL;
    //判断指定目录是否存在,不存在则创建
    if (fileExists(noteFilePath)) {
      return noteFilePath;
    }

    String noteResourcePath = noteProjectPath +
        Platform.pathSeparator +
        FILE_NAME_RESOURCE +
        Platform.pathSeparator;

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
        Map<String, dynamic> con = {
          'videoSource': videoSource,
        };
        writeJson(itemPath + Platform.pathSeparator + "base.json", con);
      }
    }

    bool createResult = createFile(noteFilePath, context: '[{"insert":""}]');
    if (createResult) {
      return noteFilePath;
    }

    return null;
  }

  static String getParentPath(String path) {
    int endIndex = path.lastIndexOf(Platform.pathSeparator);
    return path.substring(0, endIndex);
  }

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
