import 'package:flutter/material.dart';
import 'package:peerpal/app/data/resources/colors.dart';

class BottomIndicator extends StatelessWidget {
  const BottomIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: RefreshProgressIndicator(
          backgroundColor: PeerPALAppColor.primaryColor,
          color: Colors.white,
        ),
      ),
    );
  }
}
