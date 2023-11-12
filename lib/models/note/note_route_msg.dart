///笔记路由信息
abstract class NoteRouteMsg {
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

  ///笔记文件的路径
  String noteFilePosition;

  ///笔记父文件夹路径
  String? noteProjectPosition;
  String? noteResourceDirPosition;
  String? noteConfigDirPosition;
  String? noteImgDirPosition;
  String? noteVideoDirPosition;
  String? notePdfDirPosition;

  String? noteBaseConfigFilePosition;
}

///笔记路径常量
enum NotePositionConstant implements Comparable<NotePositionConstant> {
  dirImg(v: "img"),
  dirConfig(v: "config"),
  dirVideo(v: "video"),
  dirPdf(v: "pdf"),
  dirResource(v: "resource"),
  suffixHL(v: ".hl"),
  fileBaseConfig(v: "BaseConfig.json");

  const NotePositionConstant({required this.v});

  ///value
  final String v;

  @override
  int compareTo(NotePositionConstant other) {
    return this.v.hashCode == other.v.hashCode ? 0 : 1;
  }
}
