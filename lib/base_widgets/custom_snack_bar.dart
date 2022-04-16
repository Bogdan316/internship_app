import 'package:flutter/material.dart';

class MessageSnackBar extends SnackBar {
  // Builds a snack bar that pops up from the bottom, displaying
  // the message given in the constructor

  final String message;

  MessageSnackBar(this.message, {Key? key})
      : super(
          key: key,
          content: Text(message),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              // empty function, the argument is mandatory but we do not need any
              // action when pressing the button
            },
          ),
        );
}
