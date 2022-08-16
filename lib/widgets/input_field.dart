import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  var hintText = '';

  void Function(String)? onChanged;

  InputField(
      {required this.hintText, required void Function(String)? onChanged});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        color: Colors.black,
        fontSize: 15,
      ),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: 'QRegular',
          color: Colors.grey,
        ),
      ),
    );
  }
}
