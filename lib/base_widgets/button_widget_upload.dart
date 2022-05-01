import 'package:flutter/material.dart';

class ButtonWidgetUpload extends StatelessWidget{
  final IconData icon;
  final String text;
  final VoidCallback onClicked;

  /*const*/  ButtonWidgetUpload({
    Key? key,
    required this.icon,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      shape: StadiumBorder(),
      onPrimary: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    ),
    icon: Icon(icon),
    label: Text(text),
    onPressed: onClicked,
  );

}