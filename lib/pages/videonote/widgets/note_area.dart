import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:note/pages/videonote/index.dart';

class NoteArea extends GetView<VideoNoteController> {
  NoteArea({Key? key}) : super(key: key);

  QuillController _quillController = QuillController.basic();

  final controller = Get.find<VideoNoteController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                SizedBox(width: 5),
                GFIconButton(
                    type: GFButtonType.outline,
                    icon: Icon(Icons.screenshot),
                    size: GFSize.SMALL,
                    onPressed: () {
                      controller.videoScreenShot(context, "D://");
                    }),
                SizedBox(width: 5),
                GFIconButton(
                    type: GFButtonType.outline,
                    icon: Icon(Icons.flag),
                    size: GFSize.SMALL,
                    onPressed: () {}),
                SizedBox(width: 5),
                GFIconButton(
                    type: GFButtonType.outline,
                    icon: Icon(Icons.find_in_page),
                    size: GFSize.SMALL,
                    onPressed: () {}),
                SizedBox(width: 5),
                GFIconButton(
                    type: GFButtonType.outline,
                    icon: Icon(Icons.mic),
                    size: GFSize.SMALL,
                    onPressed: () {}),
                SizedBox(width: 5),
                GFIconButton(
                    type: GFButtonType.outline,
                    icon: Icon(Icons.music_note),
                    size: GFSize.SMALL,
                    onPressed: () {}),
                SizedBox(width: 5),
                GFIconButton(
                    type: GFButtonType.outline,
                    icon: Icon(Icons.live_tv),
                    size: GFSize.SMALL,
                    onPressed: () {}),
              ],
            ),
            Container(
              margin: EdgeInsets.only(right: 5),
              child: GFIconButton(
                  type: GFButtonType.outline,
                  icon: Icon(Icons.save),
                  size: GFSize.SMALL,
                  onPressed: () {}),
            ),
          ],
        ),

        // 富文本工具栏
        QuillToolbar.basic(
            controller: _quillController,
            embedButtons: FlutterQuillEmbeds.buttons(),
            customButtons: [
              QuillCustomButton(
                  icon: Icons.ac_unit,
                  onTap: () {
                    final index = _quillController.selection.baseOffset;
                    final text = '_custom_';
                    _quillController.replaceText(index, 0, text,
                        TextSelection(baseOffset: 0, extentOffset: 0));

                    // final embedData = QuillEmbedData(image: 'https://example.com/image.jpg', width: 300, height: 200);
                    // _controller.insertEmbed(0, 'image', embedData);
                  }),
            ]),

        // 富文本编辑区
        Expanded(
          child: Container(
            child: QuillEditor.basic(
              controller: _quillController,
              embedBuilders: FlutterQuillEmbeds.builders(),
              readOnly: false, // 为 true 时只读
              autoFocus: true,
            ),
          ),
        ),
      ],
    );
  }
}
