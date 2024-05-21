import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/extensions/controller_ext.dart';
import 'package:flutter_quill_extensions/flutter_quill_embeds.dart';
import 'package:flutter_quill_extensions/utils/utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

import '../../../../common/utils/common_tool.dart';
import '../../../../common/utils/file_tool.dart';
import '../../../media_display/base_media_display_controller.dart';
import '../controller.dart';
import 'link_blockembed.dart';

class FlutterQuillEditorWidget extends StatelessWidget {
  const FlutterQuillEditorWidget({
    super.key,
    required this.quillController,
    required this.flutterQuillEditorController,
    required this.mediaDisplayController,
    required this.focusNode,
  });

  ///官方富文本控制器
  final QuillController quillController;

  ///自己整个富文本控制器
  final FlutterQuillEditorController flutterQuillEditorController;

  ///媒体展示控制器
  final BaseMediaDisplayController mediaDisplayController;

  ///焦点
  final FocusNode focusNode;

  /// 复制粘贴图片(网络)
  Future<String?> _onImagePaste(Uint8List imageBytes) async {
    String imgDir = flutterQuillEditorController.state.getBaseNote().noteImgPos;
    String imgName = CommonTool.getCurrentTime() + ".jpeg";
    String? imgFilePath = await FileTool.saveImage(imageBytes, imgDir, imgName);
    if (imgFilePath == null) {
      return null;
    }
    LogUtil.d("图片保存路径为:$imgFilePath");
    return imgFilePath;
  }

  Widget _build() {
    var quillEditor = QuillEditor(
      configurations: QuillEditorConfigurations(
        placeholder: '添加内容',
        padding: EdgeInsets.all(5),
        onImagePaste: _onImagePaste,
        onTapUp: (details, p1) {
          return true;
        },
        embedBuilders: [
          ...FlutterQuillEmbeds.editorBuilders(),
          LinkEmbedBuilder(mediaDisplayController: mediaDisplayController)
        ],
        customStyles: DefaultStyles(
          h1: DefaultTextBlockStyle(
              const TextStyle(
                fontSize: 32,
                color: Colors.black,
                height: 1.15,
                fontWeight: FontWeight.w300,
              ),
              const VerticalSpacing(16, 0),
              const VerticalSpacing(0, 0),
              null),
          sizeSmall: const TextStyle(fontSize: 9),
          subscript: const TextStyle(
            fontFamily: 'SF-UI-Display',
            fontFeatures: [FontFeature.subscripts()],
          ),
          superscript: const TextStyle(
            fontFamily: 'SF-UI-Display',
            fontFeatures: [FontFeature.superscripts()],
          ),
        ),
        controller: quillController,
      ),
      scrollController: ScrollController(),
      focusNode: focusNode,
    );
    if (kIsWeb) {
      quillEditor = QuillEditor(
        configurations: QuillEditorConfigurations(
          placeholder: '添加内容',
          padding: EdgeInsets.all(5),
          onImagePaste: _onImagePaste,
          onTapUp: (details, p1) {
            return true;
          },
          embedBuilders: [
            ...FlutterQuillEmbeds.editorWebBuilders(),
            LinkEmbedBuilder(mediaDisplayController: mediaDisplayController)
          ],
          customStyles: DefaultStyles(
            h1: DefaultTextBlockStyle(
                const TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  height: 1.15,
                  fontWeight: FontWeight.w300,
                ),
                const VerticalSpacing(16, 0),
                const VerticalSpacing(0, 0),
                null),
            sizeSmall: const TextStyle(fontSize: 9),
          ),
          controller: quillController,
        ),
        scrollController: ScrollController(),
        focusNode: focusNode,
      );
    }

    return quillEditor;
  }

  @override
  Widget build(BuildContext context) {
    return _build();
  }
}
