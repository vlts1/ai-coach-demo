import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExitButton extends StatelessWidget {
  const ExitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: CupertinoButton(
        padding: EdgeInsets.only(top: 35, left: 20, right: 50, bottom: 50),
        onPressed: () {
          Navigator.of(context).pop();
          // Implement exit logic here
        },
        child: Icon(
          CupertinoIcons.xmark_circle,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}