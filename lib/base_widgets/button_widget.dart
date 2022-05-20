import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  // final Uri? url;
  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
    // this.url,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      shape: const StadiumBorder(),
      onPrimary: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    ),
    icon: const Icon(
      FontAwesomeIcons.github,
      size: 24.0,
    ),
    label: Text(text),
    onPressed: onClicked,
  );
// void _launchUrl() async {
//   if (!) throw 'Could not launch $url';
// }
}