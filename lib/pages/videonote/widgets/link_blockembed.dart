import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:getwidget/getwidget.dart';
import 'package:note/pages/my/ImageGestureResize.dart';

//使用时必须在QuillEditor的embedBuilders中注册
class LinkBlockEmbed extends Embeddable {
  LinkBlockEmbed({
    required this.editValue,
    required this.linkBlockEmbedClick,
  }) : super(key, {
          editValueKey: editValue,
          linkBlockEmbedClickKey: linkBlockEmbedClick
        });
  static const String key = 'LinkBlockEmbed';

  static const String editValueKey = 'editValueKey';
  static const String linkBlockEmbedClickKey = 'linkBlockEmbedClickKey';
  final String editValue;
  final void Function() linkBlockEmbedClick;

  static LinkBlockEmbed fromDocument(
          Document document, void Function() linkBlockEmbedClick) =>
      LinkBlockEmbed(
          editValue: jsonEncode(document.toDelta().toJson()),
          linkBlockEmbedClick: linkBlockEmbedClick);

  Document get document => Document.fromJson(jsonDecode(data));
}

class LinkEmbedBuilder extends EmbedBuilder {
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
            print(node.value.data[LinkBlockEmbed.editValueKey] as String);
            final linkBlockEmbedClick =
                node.value.data[LinkBlockEmbed.linkBlockEmbedClickKey];
            linkBlockEmbedClick();
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
