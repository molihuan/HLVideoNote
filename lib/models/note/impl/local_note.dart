import 'package:note/models/note/base_note.dart';
import 'package:note/models/note/impl/note_path_msg.dart';
import 'package:note/models/r_source.dart';

class LocalNote extends BaseNote {
  LocalNote({
    required super.noteType,
    required super.noteTitle,
    required super.noteDescription,
    required super.noteUpdateTime,
    super.noteCreateTime,
    required this.noteFilePath,
  }) : super(
          noteSourceType: SourceType.local,
          noteRouteMsg: NotePathMsg(noteFilePath: noteFilePath),
        );
  String noteFilePath;
}
