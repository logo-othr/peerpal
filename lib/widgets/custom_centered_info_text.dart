import 'package:flutter/material.dart';

class CustomCenteredInfoText extends StatelessWidget {
  const CustomCenteredInfoText({Key? key, required this.text})
      : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: Align(alignment: Alignment.center, child: Text(text)))
        ],
      ),
    );
  }
}
