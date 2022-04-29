import 'package:flutter/material.dart';

class EmojiButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String emojiCode;

  const EmojiButton(
      {Key? key, this.onPressed, required this.emojiCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onPressed, child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
          color: Colors.transparent,
          child: Text(emojiCode, style: TextStyle(fontSize: 28))
      ),
    ));
  }
}
