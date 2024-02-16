import 'package:note/models/note/base_note.dart';
import 'package:note/models/note/impl/note_http_msg.dart';
import 'package:note/models/note/impl/note_ws_msg.dart';
import 'package:note/models/r_source.dart';

class WebSocketNote extends BaseNote {
  WebSocketNote({
    required super.readMedia,
    required super.noteTitle,
    required super.noteDescription,
    required super.noteUpdateTime,
    super.noteCreateTime,
    required this.noteFileUrl,
  }) : super(
            noteSourceType: SourceType.WEB_SOCKET,
            noteRouteMsg: NoteWsMsg(noteFileUrl: noteFileUrl));
  String noteFileUrl;
}
