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
    required this.readMedia,
    required this.noteSourceType,
    required this.noteRouteMsg,
    required this.noteTitle,
    required this.noteDescription,
    this.noteCreateTime,
    required this.noteUpdateTime,
    this.noteCover,
  });

  static const String flag = "BaseNote";

  ///笔记类型
  ///阅读媒介
  ReadMedia readMedia;

  ///笔记来源(本地、网络)
  SourceType noteSourceType;

  ///笔记路由信息
  NoteRouteMsg noteRouteMsg;

  ///展示信息
  static const String noteTitleKey = "noteTitle";
  String noteTitle;
  static const String noteDescriptionKey = "noteDescription";
  String noteDescription;
  static const String noteCreateTimeKey = "noteCreateTime";
  DateTime? noteCreateTime;
  static const String noteUpdateTimeKey = "noteUpdateTime";
  DateTime noteUpdateTime;

  ///封面
  static const String noteCoverKey = "noteCover";
  String? noteCover;

  Map<String, dynamic> toJson() {
    return {
      ReadMedia.flag: {
        ReadMediaType.flag: readMedia.readMediaType.index,
        Rsource.flag: {
          Rsource.vkey: readMedia.rsource.v,
          SourceType.flag: readMedia.rsource.sourceType.index
        }
      },
      SourceType.flag: noteSourceType.index,
      NoteRouteMsg.flag: {
        NoteRouteMsg.noteFilePositionKey: noteRouteMsg.noteFilePosition,
        NoteRouteMsg.noteProjectPositionKey: noteRouteMsg.noteProjectPosition,
        NoteRouteMsg.noteResourceDirPositionKey:
            noteRouteMsg.noteResourceDirPosition,
        NoteRouteMsg.noteConfigDirPositionKey:
            noteRouteMsg.noteConfigDirPosition,
        NoteRouteMsg.noteImgDirPositionKey: noteRouteMsg.noteImgDirPosition,
        NoteRouteMsg.noteVideoDirPositionKey: noteRouteMsg.noteVideoDirPosition,
        NoteRouteMsg.notePdfDirPositionKey: noteRouteMsg.notePdfDirPosition,
        NoteRouteMsg.noteBaseConfigFilePositionKey:
            noteRouteMsg.noteBaseConfigFilePosition,
      },
      BaseNote.noteTitleKey: noteTitle,
      BaseNote.noteDescriptionKey: noteDescription,
      BaseNote.noteCreateTimeKey: noteCreateTime?.toString(),
      BaseNote.noteUpdateTimeKey: noteUpdateTime.toString(),
      BaseNote.noteCoverKey: noteCover,
    };
  }

  factory BaseNote.fromJson(Map<String, dynamic> json) {
    final readMediaJson = json[ReadMedia.flag];
    final readMediaRsourceJson = readMediaJson[Rsource.flag];
    ReadMedia readMedia = ReadMedia(
        rsource: Rsource(
            sourceType:
                SourceType.values[readMediaRsourceJson[SourceType.flag]],
            v: readMediaRsourceJson[Rsource.vkey]),
        readMediaType: ReadMediaType.values[readMediaJson[ReadMediaType.flag]]);

    SourceType noteSourceType = SourceType.values[json[SourceType.flag]];

    final noteRouteMsgJson = json[NoteRouteMsg.flag];

    NoteRouteMsg noteRouteMsg = NoteRouteMsg(
      noteFilePosition: noteRouteMsgJson[NoteRouteMsg.noteFilePositionKey],
      noteProjectPosition:
          noteRouteMsgJson[NoteRouteMsg.noteProjectPositionKey],
      noteResourceDirPosition:
          noteRouteMsgJson[NoteRouteMsg.noteResourceDirPositionKey],
      noteConfigDirPosition:
          noteRouteMsgJson[NoteRouteMsg.noteConfigDirPositionKey],
      noteImgDirPosition: noteRouteMsgJson[NoteRouteMsg.noteImgDirPositionKey],
      noteVideoDirPosition:
          noteRouteMsgJson[NoteRouteMsg.noteVideoDirPositionKey],
      notePdfDirPosition: noteRouteMsgJson[NoteRouteMsg.notePdfDirPositionKey],
      noteBaseConfigFilePosition:
          noteRouteMsgJson[NoteRouteMsg.noteBaseConfigFilePositionKey],
    );

    DateTime? noteCreateTime;

    DateTime noteUpdateTime =
        DateTime.tryParse(json[BaseNote.noteUpdateTimeKey]) ?? DateTime.now();

    return BaseNote(
        readMedia: readMedia,
        noteSourceType: noteSourceType,
        noteRouteMsg: noteRouteMsg,
        noteTitle: json[BaseNote.noteTitleKey],
        noteDescription: json[BaseNote.noteDescriptionKey],
        noteCreateTime: noteCreateTime,
        noteUpdateTime: noteUpdateTime,
        noteCover: json[BaseNote.noteCoverKey]);
  }

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
