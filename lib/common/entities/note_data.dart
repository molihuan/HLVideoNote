/**
 * --noteName1
 *   --noteName1.hl
 *   --resource
 *     --img(存放图片、截图)
 *     --config(是什么模式的笔记，存放白板数据)
 *     --video(存放视频)
 *     --pdf(存放pdf)
 */

class NoteData {
  //笔记父文件夹路径
  String? noteProjectPath;
  //笔记文件的路径
  String? noteFilePath;

  String title;
  String description;
  DateTime time;

  NoteData({
    this.noteProjectPath,
    this.noteFilePath,
    required this.title,
    required this.description,
    required this.time,
  });
}
