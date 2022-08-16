import 'package:easy_ride_driver/widgets/text.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  var buttonText = '';

  void Function() onPressed;
  Button({required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(65, 15, 65, 15),
          child: textBold(
            buttonText,
            14,
            Colors.white,
          ),
        ),
      ),
    );
  }
}
