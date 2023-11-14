import 'package:note/models/r_source.dart';
import 'package:note/models/read_media.dart';

import 'note_route_msg.dart';

/**
 * --noteName1
 *   --noteName1.hl
 *   --resource
 *     --img(存放图片、截图)
 *     --config(是什么模式的笔记，存放白板数据)
 *     --video(存放视频)
 *     --pdf(存放pdf)
 */

class BaseNote {
  BaseNote({
    required this.noteSourceType,
    required this.noteRouteMsg,
    required this.noteTitle,
    required this.noteDescription,
    required this.noteUpdateTime,
    this.noteCreateTime,
    required this.readMedia,
  });

  static const String flag = "BaseNote";

  ///笔记类型
  ///阅读媒介
  ReadMedia readMedia;

  ///笔记源
  SourceType noteSourceType;

  ///笔记路由信息
  NoteRouteMsg noteRouteMsg;

  ///展示信息
  String noteTitle;
  String noteDescription;
  DateTime? noteCreateTime;
  DateTime noteUpdateTime;

  ///封面
  String? noteCover;

  R callSwitch<R, F extends R Function(BaseNote note)>({
    required F txtCallback,
    required F videoCallback,
    required F pdfCallback,
    required F audioCallback,
    required F markdownCallback,
  }) {
    switch (readMedia.readMediaType) {
      case ReadMediaType.txt:
        return txtCallback(this);
      case ReadMediaType.video:
        return videoCallback(this);
      case ReadMediaType.pdf:
        return pdfCallback(this);
      case ReadMediaType.audio:
        return audioCallback(this);
      case ReadMediaType.markdown:
        return markdownCallback(this);
    }
  }
}

///笔记类型
enum NoteType {
  txt,
  video,
  pdf,
  audio,
  markdown,
}
