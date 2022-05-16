import 'package:flutter/material.dart';

class ButtonWidgetUpload extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onClicked;
  final Color? primary;

  const ButtonWidgetUpload({
    Key? key,
    required this.icon,
    required this.text,
    required this.onClicked,
    this.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      primary: primary,
      minimumSize: const Size(120, 45),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    icon: Icon(icon),
    label: Text(text),
    onPressed: onClicked,
  );
}
