import 'package:note/models/note/base_note.dart';
import 'package:note/models/note/impl/note_path_msg.dart';

class LocalNote extends BaseNote {
  LocalNote({
    required super.noteType,
    required super.noteTitle,
    required super.noteDescription,
    required super.noteUpdateTime,
    super.noteCreateTime,
    required this.noteFilePath,
  }) : super(
          noteSource: NoteSource.local,
          noteRouteMsg: NotePathMsg(noteFilePath: noteFilePath),
        );
  String noteFilePath;
}
