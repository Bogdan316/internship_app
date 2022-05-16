import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget{
  final int maxLines;
  final String label;
  final String text;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  const TextFieldWidget({
    Key? key,
    this.maxLines = 1,
    required this.label,
    required this.text,
    required this.onChanged,
    required this.controller,
  }) : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  // late final TextEditingController controller;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        widget.label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize:24),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        maxLines: widget.maxLines,
        onChanged: widget.onChanged,
      ),
    ],
  );
}
