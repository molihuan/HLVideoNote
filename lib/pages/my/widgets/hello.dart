import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/radio_list_tile/gf_radio_list_tile.dart';
import 'package:getwidget/getwidget.dart';
import 'package:getwidget/position/gf_position.dart';
import 'package:getwidget/types/gf_radio_type.dart';
import 'package:note/common/utils/common_tool.dart';
import 'dart:ui' as ui;

import '../index.dart';

//白板测试
class HelloWidget extends StatefulWidget {
  const HelloWidget({Key? key}) : super(key: key);

  @override
  _MyAccordionState createState() => _MyAccordionState();
}

class _MyAccordionState extends State<HelloWidget> {
  final DrawingController _drawingController = DrawingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DrawingBoard(
        controller: _drawingController,
        background: Container(width: 400, height: 400, color: Colors.white),
        showDefaultActions: true,
        showDefaultTools: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ByteData? data = await _drawingController.getImageData();

          var asInt8List = data?.buffer.asUint8List();
          CommonTool.saveImage(asInt8List, "D:/", "1.png");
          print("成功");
        },
      ),
    );
  }

  /// 获取画板数据
}
