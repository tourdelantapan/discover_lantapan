import 'package:app/utilities/constants.dart';
import 'package:app/widgets/shape/triangle.dart';
import 'package:flutter/material.dart';

class SquareBorder extends StatelessWidget {
  double? size;
  SquareBorder({Key? key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        clipBehavior: Clip.hardEdge,
        // width: 400,
        // decoration: BoxDecoration(),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          ...List.generate(
            25,
            (index) => Row(children: [
              Container(
                height: size ?? 10,
                width: size ?? 10,
                color: Colors.yellow,
              ),
              Container(
                height: size ?? 10,
                width: size ?? 10,
                color: Colors.black,
              ),
            ]),
          )
        ]));
  }
}
