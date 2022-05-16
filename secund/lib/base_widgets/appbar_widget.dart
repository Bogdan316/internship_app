import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

AppBar buildAppBar(BuildContext context) {
  //final icon=CupertinoIcons.moon_stars;

  return AppBar(
    leading: BackButton(),
    backgroundColor: Color(0xFF01135d),//Colors.blueAccent,
    elevation: 0,
    //actions: [
      //IconButton(
        //icon: Icon(icon),
        //onPressed: (){},
      //),
    //],
  );
}