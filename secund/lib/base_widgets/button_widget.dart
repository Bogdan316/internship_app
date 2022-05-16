import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ButtonWidget extends StatelessWidget{
  final String text;
  final VoidCallback onClicked;

  /*const*/  ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  /*
  @override
  Widget build(BuildContext context) => Center(
    child: Link(
      target: LinkTarget.self,
      uri: Uri.parse('https://flutter.dev'),
      builder: (context, followLink) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
          onPrimary: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        child: Text(text),
        onPressed: followLink,
      ),
    ),
  );
*/

  final Uri _url = Uri.parse('https://flutter.dev');

  /*
  @override
  Widget build(BuildContext context) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      shape: StadiumBorder(),
      onPrimary: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    ),
    child: Text(text),
    onPressed: _launchUrl,
  );

  void _launchUrl() async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }
*/

  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      shape: StadiumBorder(),
      onPrimary: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    ),
    icon: Icon(
        FontAwesomeIcons.github,
        /*Icon( // <-- Icon
      Icons.download,*/
      size: 24.0,
    ),
    label: Text(text),
    onPressed: _launchUrl,
  );

  void _launchUrl() async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

 /*Aici ma intorc daca nu merge
  @override
  Widget build(BuildContext context) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      shape: StadiumBorder(),
      onPrimary: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    ),
    child: Text(text),
      onPressed: onClicked,
  );
  */
}