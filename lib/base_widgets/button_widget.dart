import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ButtonWidget extends StatelessWidget{
  final String text;
  final VoidCallback onClicked;
  final Uri url;

  ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
    required this.url,
  }) : super(key: key);

  //final Uri _url = Uri.parse(link);


  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      shape: StadiumBorder(),
      onPrimary: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    ),
    icon: Icon(
        FontAwesomeIcons.github,
      size: 24.0,
    ),
    label: Text(text),
    onPressed: _launchUrl,
  );

  void _launchUrl() async {
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }

}