import 'package:flutter/material.dart';

class CustomElevatedButton extends ElevatedButton {
  // Builds a custom button layout with rounded corners that should be the
  // default shape for all the buttons in the app

  CustomElevatedButton({
    Key? key,
    required VoidCallback? onPressed,
    required String label,
    required Color? primary,
  }) : super(
          key: key,
          style: ElevatedButton.styleFrom(
            primary: primary,
            minimumSize: const Size(110, 40),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        );
}
