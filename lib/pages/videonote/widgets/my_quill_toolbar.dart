import 'dart:io' as io show File;

import 'package:flutter/material.dart';

import 'package:flutter_quill/extensions.dart' show isAndroid, isIOS, isWeb;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:image_cropper/image_cropper.dart';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

import '../../../dao/data_manager.dart';
import '../controllers/quill_text_controller.dart';
import '../controllers/video_player_controller.dart';
import 'dialogs/insert_image_dialog.dart';

class MyQuillToolbar extends StatelessWidget {
  MyQuillToolbar({
    required this.quillController,
    required this.focusNode,
    super.key,
  });

  final QuillController quillController;
  final FocusNode focusNode;
  final videoPlayerController = Get.find<VideoPlayerController>();
  final quillTextController = Get.find<QuillTextController>();

  Future<void> onImageInsertWithCropping(
    String image,
    QuillController controller,
    BuildContext context,
  ) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: image,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    final newImage = croppedFile?.path;
    if (newImage == null) {
      return;
    }
    if (isWeb()) {
      controller.insertImageBlock(imageSource: newImage);
      return;
    }
    final newSavedImage = await saveImage(io.File(newImage));
    controller.insertImageBlock(imageSource: newSavedImage);
  }

  Future<void> onImageInsert(String image, QuillController controller) async {
    if (isWeb() || isHttpBasedUrl(image)) {
      controller.insertImageBlock(imageSource: image);
      return;
    }
    final newSavedImage = await saveImage(io.File(image));
    controller.insertImageBlock(imageSource: newSavedImage);
  }

  /// For mobile platforms it will copies the picked file from temporary cache
  /// to applications directory
  ///
  /// for desktop platforms, it will do the same but from user files this time
  Future<String> saveImage(io.File file) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final fileExt = path.extension(file.path);
    final newFileName = '${DateTime.now().toIso8601String()}$fileExt';
    final newPath = path.join(
      appDocDir.path,
      newFileName,
    );
    final copiedFile = await file.copy(newPath);
    return copiedFile.path;
  }

  @override
  Widget build(BuildContext context) {
    return QuillToolbar(
      child: Wrap(
        children: [
          IconButton(
              tooltip: "返回",
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
              }),
          IconButton(
              tooltip: "保存",
              icon: Icon(Icons.save),
              onPressed: () {
                bool result = quillTextController.saveNote();
                if (result) {
                  SmartDialog.showToast('保存成功');
                } else {
                  SmartDialog.showToast('保存失败');
                }
              }),
          Obx(() {
            return Visibility(
              visible: quillTextController.state.showMoreToolbarBtn,
              child: QuillToolbarHistoryButton(
                isUndo: true,
                controller: quillController,
              ),
            );
          }),
          Obx(() {
            return Visibility(
              visible: quillTextController.state.showMoreToolbarBtn,
              child: QuillToolbarHistoryButton(
                isUndo: false,
                controller: quillController,
              ),
            );
          }),
          IconButton(
              tooltip: "截屏",
              icon: Icon(Icons.screenshot),
              onPressed: () async {
                quillTextController.insertVideoAnchor(quillController);
                String imgDir =
                    quillTextController.state.getBaseNote().noteImgPos;
                videoPlayerController.videoScreenShot(imgDir, (absolutePath) {
                  quillTextController.insertImageBlockEmbed(absolutePath);
                });
              }),
          IconButton(
              tooltip: "插入时间点",
              icon: Icon(Icons.add_alarm_rounded),
              onPressed: () {
                quillTextController.insertVideoAnchor(quillController);
              }),
          Obx(() {
            return Visibility(
              visible: quillTextController.state.showMoreToolbarBtn,
              child: IconButton(
                  tooltip: "插入图片",
                  icon: Icon(Icons.image),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) => InsertImageDialog(),
                    );
                  }),
            );
          }),
          Obx(() {
            return Visibility(
              visible: quillTextController.state.showMoreToolbarBtn,
              child: IconButton(
                  tooltip: "插入照片",
                  icon: Icon(Icons.photo_camera),
                  onPressed: () {}),
            );
          }),
          Obx(() {
            return Visibility(
              visible: quillTextController.state.showMoreToolbarBtn,
              child: IconButton(
                  tooltip: "插入音频",
                  icon: Icon(Icons.music_note),
                  onPressed: () {}),
            );
          }),
          Obx(() {
            return Visibility(
              visible: quillTextController.state.showMoreToolbarBtn,
              child: IconButton(
                  tooltip: "插入录音", icon: Icon(Icons.mic), onPressed: () {}),
            );
          }),
          Obx(() {
            return Visibility(
              visible: quillTextController.state.showMoreToolbarBtn,
              child: IconButton(
                  tooltip: "插入视频",
                  icon: Icon(Icons.movie_creation),
                  onPressed: () {}),
            );
          }),
          Obx(() {
            return Visibility(
              visible: quillTextController.state.showMoreToolbarBtn,
              child: IconButton(
                  tooltip: "文本查找",
                  icon: Icon(Icons.find_in_page),
                  onPressed: () {}),
            );
          }),
          Obx(() {
            return Visibility(
              visible: quillTextController.state.showMoreToolbarBtn,
              child: IconButton(
                  tooltip: "导出",
                  icon: Icon(Icons.unarchive_outlined),
                  onPressed: () {
                    // final msc = Get.find<MultiSplitController>();
                    // msc.setAxis(Axis.vertical);
                  }),
            );
          }),
          Obx(() {
            return Visibility(
              visible: quillTextController.state.showMoreToolbarBtn,
              child: QuillToolbarToggleStyleButton(
                options: const QuillToolbarToggleStyleButtonOptions(),
                controller: quillController,
                attribute: Attribute.bold,
              ),
            );
          }),
          Obx(() {
            return Visibility(
              visible: quillTextController.state.showMoreToolbarBtn,
              child: QuillToolbarToggleStyleButton(
                options: const QuillToolbarToggleStyleButtonOptions(),
                controller: quillController,
                attribute: Attribute.italic,
              ),
            );
          }),
          Obx(() {
            return Visibility(
              visible: quillTextController.state.showMoreToolbarBtn,
              child: QuillToolbarToggleStyleButton(
                controller: quillController,
                attribute: Attribute.underline,
              ),
            );
          }),
          Obx(() {
            return Visibility(
              visible: quillTextController.state.showMoreToolbarBtn,
              child: QuillToolbarToggleStyleButton(
                controller: quillController,
                attribute: Attribute.subscript,
              ),
            );
          }),
          Obx(() {
            return Visibility(
              visible: quillTextController.state.showMoreToolbarBtn,
              child: QuillToolbarToggleStyleButton(
                controller: quillController,
                attribute: Attribute.superscript,
              ),
            );
          }),
          Obx(() {
            return Visibility(
              visible: quillTextController.state.showMoreToolbarBtn,
              child: QuillToolbarClearFormatButton(
                controller: quillController,
              ),
            );
          }),
          const VerticalDivider(),
          Obx(() {
            return Visibility(
              visible: quillTextController.state.showMoreToolbarBtn,
              child: QuillToolbarColorButton(
                controller: quillController,
                isBackground: false,
              ),
            );
          }),
          Obx(() {
            return Visibility(
              visible: quillTextController.state.showMoreToolbarBtn,
              child: QuillToolbarColorButton(
                controller: quillController,
                isBackground: true,
              ),
            );
          }),
          QuillToolbarSelectHeaderStyleDropdownButton(
            controller: quillController,
            options:
                QuillToolbarSelectHeaderStyleDropdownButtonOptions(attributes: [
              Attribute.h1,
              Attribute.h2,
              Attribute.h3,
              Attribute.h4,
              Attribute.h5,
              Attribute.h6,
              Attribute.header,
            ]),
          ),
          Obx(() {
            return Visibility(
              visible: quillTextController.state.showMoreToolbarBtn,
              child: QuillToolbarFontFamilyButton(
                controller: quillController,
                options: QuillToolbarFontFamilyButtonOptions(rawItemsMap: {
                  'Amatic': GoogleFonts.amaticSc().fontFamily!,
                  'Annie': GoogleFonts.annieUseYourTelescope().fontFamily!,
                  'Formal': GoogleFonts.petitFormalScript().fontFamily!,
                  'Roboto': GoogleFonts.roboto().fontFamily!
                }),
              ),
            );
          }),
          QuillToolbarToggleCheckListButton(
            controller: quillController,
          ),
          QuillToolbarToggleStyleButton(
            controller: quillController,
            attribute: Attribute.ol,
          ),
          QuillToolbarToggleStyleButton(
            controller: quillController,
            attribute: Attribute.ul,
          ),
          QuillToolbarToggleStyleButton(
            controller: quillController,
            attribute: Attribute.leftAlignment,
          ),
          QuillToolbarToggleStyleButton(
            controller: quillController,
            attribute: Attribute.centerAlignment,
          ),
          QuillToolbarToggleStyleButton(
            controller: quillController,
            attribute: Attribute.rightAlignment,
          ),
          QuillToolbarToggleStyleButton(
            controller: quillController,
            attribute: Attribute.justifyAlignment,
          ),
          Obx(() {
            return Visibility(
              visible: quillTextController.state.showMoreToolbarBtn,
              child: QuillToolbarToggleStyleButton(
                controller: quillController,
                attribute: Attribute.inlineCode,
              ),
            );
          }),
          Obx(() {
            return Visibility(
              visible: quillTextController.state.showMoreToolbarBtn,
              child: QuillToolbarToggleStyleButton(
                controller: quillController,
                attribute: Attribute.blockQuote,
              ),
            );
          }),
          Obx(() {
            return Visibility(
              visible: quillTextController.state.showMoreToolbarBtn,
              child: QuillToolbarIndentButton(
                controller: quillController,
                isIncrease: true,
              ),
            );
          }),
          Obx(() {
            return Visibility(
              visible: quillTextController.state.showMoreToolbarBtn,
              child: QuillToolbarIndentButton(
                controller: quillController,
                isIncrease: false,
              ),
            );
          }),
          Obx(() {
            return Visibility(
              visible: quillTextController.state.showMoreToolbarBtn,
              child: QuillToolbarLinkStyleButton(controller: quillController),
            );
          }),
          Obx(() {
            // 通过条件判断来决定显示的按钮，并直接在此处处理状态改变，减少重复代码
            final showMoreBtn = quillTextController.state.showMoreToolbarBtn;
            return IconButton(
              // 根据showMoreBtn的值动态设置图标和onPressed事件
              tooltip: showMoreBtn ? "隐藏按钮" : "更多按钮", // 根据状态改变提示文本
              icon: showMoreBtn
                  ? const Icon(Icons.width_normal)
                  : Icon(Icons.dashboard_customize),
              onPressed: () {
                // 动态更改状态，并通知数据变化
                quillTextController.state.showMoreToolbarBtn = !showMoreBtn;
                DataManager.setShowMoreToolbarBtn(!showMoreBtn);
              },
            );
          }),
        ],
      ),
      configurations: QuillToolbarConfigurations(),
    );
  }
}
