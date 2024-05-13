import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';

import '../../../common/utils/file_tool.dart';

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
          FileTool.saveImage(asInt8List!, "D:/", "1.png");
          print("成功");
        },
      ),
    );
  }

  /// 获取画板数据
}
