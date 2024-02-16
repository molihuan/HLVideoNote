import 'package:note/models/note/base_note.dart';
import 'package:note/models/note/impl/note_http_msg.dart';
import 'package:note/models/r_source.dart';

class HttpNote extends BaseNote {
  HttpNote({
    required super.readMedia,
    required super.noteTitle,
    required super.noteDescription,
    required super.noteUpdateTime,
    super.noteCreateTime,
    required this.noteFileUrl,
  }) : super(
            noteSourceType: SourceType.HTTP,
            noteRouteMsg: NoteHttpMsg(noteFileUrl: noteFileUrl));
  String noteFileUrl;
}
