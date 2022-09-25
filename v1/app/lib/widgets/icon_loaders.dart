import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

showDoubleBounce({double? size}) {
  return SpinKitDoubleBounce(
    size: size ?? 30,
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: index.isEven ? Colors.red : Colors.red.withOpacity(0.7),
        ),
      );
    },
  );
}
