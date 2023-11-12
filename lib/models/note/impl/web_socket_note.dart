import 'package:note/models/note/base_note.dart';
import 'package:note/models/note/impl/note_url_msg.dart';

class WebSocketNote extends BaseNote {
  WebSocketNote({
    required super.noteType,
    required super.noteTitle,
    required super.noteDescription,
    required super.noteUpdateTime,
    super.noteCreateTime,
    required this.noteFileUrl,
  }) : super(
            noteSource: NoteSource.webSocket,
            noteRouteMsg: NoteUrlMsg(noteFileUrl: noteFileUrl));
  String noteFileUrl;
}
