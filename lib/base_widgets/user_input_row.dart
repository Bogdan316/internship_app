import 'package:flutter/material.dart';

class UserInputRow extends StatefulWidget {
  // Builds a custom row containing a TextField for user input, should be the
  // default for all TextFields in the app

  final bool obscureText;
  final String? labelText;
  final Icon? icon;
  final TextEditingController? controller;
  final Color? color;

  const UserInputRow(
      {this.labelText,
      this.icon,
      this.controller,
      this.color,
      this.obscureText = false,
      Key? key})
      : super(key: key);

  @override
  State<UserInputRow> createState() => _UserInputRowState();
}

class _UserInputRowState extends State<UserInputRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.icon != null) widget.icon!,
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(10),
            height: 40,
            child: TextField(
              style: TextStyle(
                fontSize: 15,
                color: widget.color,
              ),
              obscureText: widget.obscureText,
              controller: widget.controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                labelText: widget.labelText,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
