import 'package:app/utilities/constants.dart';
import 'package:app/widgets/shape/triangle.dart';
import 'package:flutter/material.dart';

class DiamondBorder extends StatelessWidget {
  const DiamondBorder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 5,
          color: Colors.black,
          width: double.infinity,
        ),
        Container(
          height: 5,
          color: Colors.yellow,
          width: double.infinity,
        ),
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
        Container(
          height: 5,
          color: Colors.yellow,
          width: double.infinity,
        ),
        Container(
          height: 5,
          color: Colors.black,
          width: double.infinity,
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
