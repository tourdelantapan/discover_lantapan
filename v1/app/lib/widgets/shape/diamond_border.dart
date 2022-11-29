import 'package:app/utilities/constants.dart';
import 'package:app/widgets/shape/triangle.dart';
import 'package:flutter/material.dart';

class DiamondBorder extends StatelessWidget {
  double? decreaseSize;
  DiamondBorder({Key? key, this.decreaseSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 5 - (decreaseSize ?? 0),
          color: const Color.fromARGB(255, 36, 30, 32),
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
                      height: 15 - (decreaseSize ?? 0),
                      width: 20 - (decreaseSize ?? 0),
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
                          height: 15 - (decreaseSize ?? 0),
                          width: 20 - (decreaseSize ?? 0),
                        )))
              ],
            ),
          )
        ]),
        Container(
          height: 5 - (decreaseSize ?? 0),
          color: Colors.yellow,
          width: double.infinity,
        ),
        Container(
          height: 5 - (decreaseSize ?? 0),
          color: const Color.fromARGB(255, 36, 30, 32),
          width: double.infinity,
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
