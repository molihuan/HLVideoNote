///编辑器的控制器接口
mixin BaseEditorController {
  ///保存笔记
  bool saveNote();

  ///插入视频锚点
  bool insertVideoAnchor();

  ///插入图片
  bool insertImage(String pos);

  ///插入时间锚点
  bool insertTimeAnchor();
}
