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

  static bool writeJson(String filePath, contents) {
    final file = File(filePath);
    try {
      final jsonString = jsonEncode(contents);
      file.writeAsStringSync(jsonString);
      return true;
    } catch (e) {
      print('文件写入失败: $e');
      return false;
    }
  }

  static String? createNoteProjectFile(
      String noteSavePath, String noteNameNoSuffix) {
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
    }

    bool createResult = createFile(noteFilePath);
    if (createResult) {
      return noteFilePath;
    }

    return null;
  }

  static bool createFile(String filePath) {
    File file = File(filePath);
    try {
      file.createSync(recursive: true); // 创建文件
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
