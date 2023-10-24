import 'package:flutter/material.dart';

//可以拖拽的布局
class DragDividerPage extends StatefulWidget {
  @override
  _DragDividerPageState createState() => _DragDividerPageState();
}

class _DragDividerPageState extends State<DragDividerPage> {
  double dividerPosition = 0.5;
  double minPosition = 0.25;
  double maxPosition = 0.75;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: (dividerPosition * 100).round(),
                  child: Container(
                    color: Colors.blue,
                    child: Center(
                      child: Text('Left Text'),
                    ),
                  ),
                ),
                GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      dividerPosition += details.delta.dx / context.size!.width;
                      if (dividerPosition < minPosition) {
                        dividerPosition = minPosition;
                      } else if (dividerPosition > maxPosition) {
                        dividerPosition = maxPosition;
                      }
                    });
                  },
                  child: Container(
                    width: 4.0,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  flex: ((1 - dividerPosition) * 100).round(),
                  child: Container(
                    color: Colors.orange,
                    child: Center(
                      child: Text('Right Text'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
