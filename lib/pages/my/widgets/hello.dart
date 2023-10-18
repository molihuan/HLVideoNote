import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/radio_list_tile/gf_radio_list_tile.dart';
import 'package:getwidget/getwidget.dart';
import 'package:getwidget/position/gf_position.dart';
import 'package:getwidget/types/gf_radio_type.dart';

import '../index.dart';

class HelloWidget extends StatefulWidget {
  const HelloWidget({Key? key}) : super(key: key);

  @override
  _MyAccordionState createState() => _MyAccordionState();
}

class _MyAccordionState extends State<HelloWidget> {
  bool _isExpanded = false;
  final co = ExpansionTileController();

  @override
  Widget build(BuildContext context) {
    return DrawingBoard(
      background: Container(width: 400, height: 400, color: Colors.white),
      showDefaultActions: true,

      /// 开启默认操作选项
      showDefaultTools: true,

      /// 开启默认工具栏
    );
  }
}
