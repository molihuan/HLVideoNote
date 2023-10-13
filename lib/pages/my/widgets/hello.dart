import 'package:flutter/material.dart';
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
    return Column();
  }
}
