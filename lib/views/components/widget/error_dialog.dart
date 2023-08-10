import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget{
  final String? title;
  final String? message;
  final String? buttonText;
  final Function? onPressed;
  const ErrorDialog({
    Key? key,
    this.title,
    this.message,
    this.buttonText,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title ?? 'Error'),
      content: Text(message ?? 'Something went wrong'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(buttonText ?? 'OK'),
        ),
      ],
    );
  }
}