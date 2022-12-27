import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedButton extends StatelessWidget {
  final Color color;
  final String buttonTitle;
  final VoidCallback onPressed;
  RoundedButton(this.onPressed, this.color, this.buttonTitle);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            buttonTitle,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.black,
              fontFamily: 'AudioWide',
            ),
          ),
        ),
      ),
    );
  }
}
