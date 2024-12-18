import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';

class PeerPALNextButton extends StatelessWidget {
  const PeerPALNextButton({Key? key, required this.onPressed})
      : super(key: key);

  final AsyncCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomPeerPALButton(
      text: "Weiter",
      onPressed: onPressed,
    );
  }
}
