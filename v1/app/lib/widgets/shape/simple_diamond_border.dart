import 'package:app/utilities/constants.dart';
import 'package:app/widgets/shape/triangle.dart';
import 'package:flutter/material.dart';

class SimpleDiamondBorder extends StatelessWidget {
  const SimpleDiamondBorder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          ...List.generate(
            10,
            (index) => Column(
              children: [
                CustomPaint(
                    painter: TrianglePainter(
                      strokeColor: colorBG2,
                      strokeWidth: 0,
                      paintingStyle: PaintingStyle.fill,
                    ),
                    child: Container(
                      height: 15,
                      width: 20,
                    )),
                Transform.rotate(
                    angle: 3.14 / 1,
                    child: CustomPaint(
                        painter: TrianglePainter(
                          strokeColor: colorBG2,
                          strokeWidth: 0,
                          paintingStyle: PaintingStyle.fill,
                        ),
                        child: Container(
                          height: 15,
                          width: 20,
                        )))
              ],
            ),
          )
        ]),
      ],
    );
  }
}
