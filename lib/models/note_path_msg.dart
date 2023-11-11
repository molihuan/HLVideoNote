import 'package:note/common/utils/file_tool.dart';

class NotePathMsg {
  static const String FILE_NAME_IMG = "img";
  static const String FILE_NAME_CONFIG = "config";
  static const String FILE_NAME_VIDEO = "video";
  static const String FILE_NAME_PDF = "pdf";
  static const String FILE_NAME_RESOURCE = "resource";
  static const String FILE_NAME_SUFFIX_HL = ".hl";
  static const String FILE_NAME_BASE_CONFIG_JSON = "BaseConfig.json";

  NotePathMsg(
      {required this.noteFilePath,
      this.noteProjectPath,
      this.noteResourceDirPath,
      this.noteConfigDirPath,
      this.noteImgDirPath,
      this.noteVideoDirPath,
      this.notePdfDirPath}) {
    if (this.noteProjectPath == null) {
      this.noteProjectPath = FileTool.getParentPath(noteFilePath);
    }

    if (this.noteResourceDirPath == null) {
      // this.noteResourceDirPath = join(this.noteProjectPath, FILE_NAME_RESOURCE);
    }
  }

  ///笔记文件的路径
  String noteFilePath;

  ///笔记父文件夹路径
  String? noteProjectPath;
  String? noteResourceDirPath;
  String? noteConfigDirPath;
  String? noteImgDirPath;
  String? noteVideoDirPath;
  String? notePdfDirPath;
}
