import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final IconData icon;
  const ButtonWidget(
      {Key? key,
      required this.text,
      required this.onClicked,
      required this.icon})
      : super(key: key);
  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColorDark,
          minimumSize: const Size(120, 45),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        icon: Icon(
          icon,

          // Icons.download,
          size: 24.0,
        ),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        onPressed: onClicked,
      );
}
