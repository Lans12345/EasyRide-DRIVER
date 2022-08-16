import 'package:flutter/material.dart';

Widget textReg(String txt, double size, Color color) {
  return Text(
    txt,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: size,
      color: color,
      fontFamily: 'QRegular',
    ),
  );
}

Widget textBold(String txt, double size, Color color) {
  return Text(
    txt,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: size,
      color: color,
      fontFamily: 'QBold',
    ),
  );
}

class TextBold extends StatelessWidget {
  var title = '';
  double fontSize = 0;
  late Color color;

  TextBold({
    required this.color,
    required this.fontSize,
    required this.title,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'QBold',
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}

class TextReg extends StatelessWidget {
  var title = '';
  double fontSize = 0;
  late Color color;

  TextReg({
    required this.color,
    required this.fontSize,
    required this.title,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'QRegular',
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}
