import 'package:note/models/r_source.dart';

///阅读媒介
class ReadMedia<T> {
  ReadMedia({required this.rsource, required this.readMediaType});

  static const String flag = "ReadMedia";

  ///是否本地、网络
  Rsource<T> rsource;

  ///阅读媒介的类型
  ReadMediaType readMediaType;
}

///笔记类型
enum ReadMediaType {
  txt,
  video,
  pdf,
  audio,
  markdown,
}
