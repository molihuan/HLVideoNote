import 'package:note/common/utils/file_tool.dart';
import 'package:note/models/note/note_route_msg.dart';
import 'package:path/path.dart';

///笔记路径信息
class NotePathMsg extends NoteRouteMsg {
  NotePathMsg({
    required this.noteFilePath,
    super.noteProjectPosition,
    super.noteConfigDirPosition,
    super.noteImgDirPosition,
    super.notePdfDirPosition,
    super.noteResourceDirPosition,
    super.noteVideoDirPosition,
    super.noteBaseConfigFilePosition,
  }) : super(noteFilePosition: noteFilePath) {
    noteProjectPosition ??= FileTool.getParentPath(noteFilePath);
    if (noteProjectPosition == null) {
      return;
    }
    noteResourceDirPosition ??=
        join(noteProjectPosition!, NotePositionConstant.dirResource.v);

    noteConfigDirPosition ??=
        join(noteResourceDirPosition!, NotePositionConstant.dirConfig.v);

    noteImgDirPosition ??=
        join(noteResourceDirPosition!, NotePositionConstant.dirImg.v);

    noteVideoDirPosition ??=
        join(noteResourceDirPosition!, NotePositionConstant.dirVideo.v);

    notePdfDirPosition ??=
        join(noteResourceDirPosition!, NotePositionConstant.dirPdf.v);

    noteBaseConfigFilePosition ??=
        join(noteConfigDirPosition!, NotePositionConstant.fileBaseConfig.v);
  }

  ///笔记文件的路径
  String noteFilePath;
}
