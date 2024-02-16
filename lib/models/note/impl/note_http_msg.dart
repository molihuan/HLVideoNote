import 'package:note/common/utils/common_tool.dart';
import 'package:note/models/note/note_route_msg.dart';
import 'package:path/path.dart';

///笔记url路径信息
class NoteHttpMsg extends NoteRouteMsg {
  NoteHttpMsg({
    required this.noteFileUrl,
    super.noteProjectPosition,
    super.noteConfigDirPosition,
    super.noteImgDirPosition,
    super.notePdfDirPosition,
    super.noteResourceDirPosition,
    super.noteVideoDirPosition,
  }) : super(noteFilePosition: noteFileUrl) {
    noteProjectPosition ??= CommonTool.getParentUrl(noteFileUrl);
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
  }

  ///笔记文件的路径
  String noteFileUrl;
}
