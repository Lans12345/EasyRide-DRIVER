import 'package:flutter/material.dart';

Widget image(
  String path,
  double height,
  double width,
  EdgeInsets e,
) {
  return Padding(
    padding: e,
    child: Image(
      fit: BoxFit.contain,
      width: width,
      height: height,
      image: AssetImage(path),
    ),
  );
}
