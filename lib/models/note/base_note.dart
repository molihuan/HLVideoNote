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
    required this.noteType,
    required this.noteSource,
    required this.noteRouteMsg,
    required this.noteTitle,
    required this.noteDescription,
    required this.noteUpdateTime,
    this.noteCreateTime,
  });

  ///笔记类型
  NoteType noteType;

  ///笔记源
  NoteSource noteSource;

  ///笔记路由信息
  NoteRouteMsg noteRouteMsg;

  ///展示信息
  String noteTitle;
  String noteDescription;
  DateTime? noteCreateTime;
  DateTime noteUpdateTime;

  ///封面
  String? noteCover;
}

///笔记类型
enum NoteType {
  txt,
  video,
  pdf,
  audio,
  markdown,
}

///笔记源
enum NoteSource {
  local,

  ///包括http和https
  http,
  webSocket,
}
