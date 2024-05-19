import 'package:get/get.dart';

class GlobalStore {
  ///全局状态(单例模式)
  GlobalStore._();

  static final GlobalStore _instance = GlobalStore._();

  factory GlobalStore() => _instance;

  final _noteShowMode = NoteShowMode.LOCAL_SHOW_MEDIA_AND_NOTE_TOGETHER.obs;

  set noteShowMode(value) => _noteShowMode.value = value;

  get noteShowMode => _noteShowMode.value;
}

///笔记显示模式
enum NoteShowMode {
  ///本地模式显示媒体和笔记(在一起)
  LOCAL_SHOW_MEDIA_AND_NOTE_TOGETHER,

  ///本地模式显示媒体和笔记(分开)
  LOCAL_SHOW_MEDIA_AND_NOTE_SEPARATE,

  ///远程模式显示媒体和笔记
  REMOTE_SHOW_MEDIA_AND_NOTE,

  ///远程模式显示媒体
  REMOTE_SHOW_MEDIA,

  ///远程模式显示笔记
  REMOTE_SHOW_NOTE,
}
