import 'package:flutter/material.dart';
import '../constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size(400, 60)),
          backgroundColor: MaterialStateProperty.all(Colors.white),
          overlayColor: MaterialStateProperty.all(Colors.black54),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(color: Colors.black)))),
      child: FittedBox(
        child: Text(
          text,
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
