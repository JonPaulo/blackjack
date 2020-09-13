import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final text;
  final textColor;
  final Function onPressed;
  final buttonColor;

  ActionButton({this.text, this.textColor, this.onPressed, this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: Border.all(width: 0.5),
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      onPressed: onPressed,
      elevation: 5,
      color: buttonColor,
    );
  }
}
