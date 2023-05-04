import 'package:flutter/material.dart';
import 'package:peerpal/app/data/resources/colors.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({Key? key, required this.text})
      : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(PeerPALAppColor.primaryColor),
              )),
          SizedBox(height: 20),
          Text(text)
        ],
      ),
    );
  }
}
