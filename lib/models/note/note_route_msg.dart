class tt {
  String vv = "1";
}

///笔记路由信息
class NoteRouteMsg {
  NoteRouteMsg({
    required this.noteFilePosition,
    this.noteProjectPosition,
    this.noteResourceDirPosition,
    this.noteConfigDirPosition,
    this.noteImgDirPosition,
    this.noteVideoDirPosition,
    this.notePdfDirPosition,
    this.noteBaseConfigFilePosition,
  });

  static const String flag = "NoteRouteMsg";

  ///笔记文件的路径
  static const String noteFilePositionKey = "noteFilePosition";
  String noteFilePosition;

  ///笔记父文件夹路径
  static const String noteProjectPositionKey = "noteProjectPosition";
  String? noteProjectPosition;
  static const String noteResourceDirPositionKey = "noteResourceDirPosition";
  String? noteResourceDirPosition;
  static const String noteConfigDirPositionKey = "noteConfigDirPosition";
  String? noteConfigDirPosition;
  static const String noteImgDirPositionKey = "noteImgDirPosition";
  String? noteImgDirPosition;
  static const String noteVideoDirPositionKey = "noteVideoDirPosition";
  String? noteVideoDirPosition;
  static const String notePdfDirPositionKey = "notePdfDirPosition";
  String? notePdfDirPosition;
  static const String noteBaseConfigFilePositionKey =
      "noteBaseConfigFilePosition";
  String? noteBaseConfigFilePosition;
}

///笔记路径常量
enum NotePositionConstant {
  dirImg(v: "img"),
  dirConfig(v: "config"),
  dirVideo(v: "video"),
  dirPdf(v: "pdf"),
  dirResource(v: "resource"),
  suffixHL(v: ".hl"),
  fileBaseConfig(v: "BaseConfig.json");

  const NotePositionConstant({required this.v});

  static const String flag = "NotePositionConstant";

  ///value
  final String v;
}
