import 'package:flutter/material.dart';

import '../media_display/base_media_display_controller.dart';
import 'flutter_quill_editor/widgets/quill_editor_toolbar_widget.dart';
import 'flutter_quill_editor/widgets/quill_editor_widget.dart';

///编辑器的控制器接口
mixin BaseEditorController {
  late final BaseMediaDisplayController mediaDisplayController;

  ///保存笔记
  bool saveNote();

  ///插入视频锚点
  bool insertVideoAnchor();

  ///插入图片
  bool insertImage(String pos);

  ///插入时间锚点
  bool insertTimeAnchor();

  QuillEditorToolbarWidget getQuillToolbarWidget();

  QuillEditorWidget getQuillEditorWidget();

  @mustCallSuper
  void setMediaDisplayController(BaseMediaDisplayController controller) {
    mediaDisplayController = controller;
    afterSetMediaDisplayController(mediaDisplayController);
  }

  void afterSetMediaDisplayController(
      BaseMediaDisplayController mediaDisplayController) {}
}
