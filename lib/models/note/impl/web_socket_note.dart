import 'package:note/models/note/base_note.dart';
import 'package:note/models/note/impl/note_url_msg.dart';
import 'package:note/models/r_source.dart';

class WebSocketNote extends BaseNote {
  WebSocketNote({
    required super.noteType,
    required super.noteTitle,
    required super.noteDescription,
    required super.noteUpdateTime,
    super.noteCreateTime,
    required this.noteFileUrl,
  }) : super(
            noteSourceType: SourceType.webSocket,
            noteRouteMsg: NoteUrlMsg(noteFileUrl: noteFileUrl));
  String noteFileUrl;
}
