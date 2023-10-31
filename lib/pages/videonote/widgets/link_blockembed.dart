import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:note/pages/videonote/controller.dart';

//使用时必须在QuillEditor的embedBuilders中注册
class LinkBlockEmbed extends Embeddable {
  LinkBlockEmbed({
    required this.editValue,
  }) : super(key, {editValueKey: editValue});
  static const String key = 'LinkBlockEmbed';
  static const String editValueKey = 'editValueKey';
  final String editValue;

  static LinkBlockEmbed fromDocument(Document document) => LinkBlockEmbed(
        editValue: jsonEncode(document.toDelta().toJson()),
      );

  Document get document => Document.fromJson(jsonDecode(data));
}

class LinkEmbedBuilder extends EmbedBuilder {
  LinkEmbedBuilder({required this.videoNoteController});

  VideoNoteController videoNoteController;

  @override
  String get key => 'LinkBlockEmbed';

  @override
  String toPlainText(Embed embed) {
    return embed.value.data[LinkBlockEmbed.editValueKey];
  }

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    return Row(
      children: [
        Icon(Icons.access_time_rounded),
        GestureDetector(
          onTap: () {
            String targetDuration =
                node.value.data[LinkBlockEmbed.editValueKey] as String;
            videoNoteController.playerSeek(durationStr: targetDuration);
          },
          child: Text(
            node.value.data[LinkBlockEmbed.editValueKey] as String,
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
