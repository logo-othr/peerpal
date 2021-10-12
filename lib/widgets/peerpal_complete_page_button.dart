import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/widgets/peerpal_next_button.dart';
import 'package:peerpal/widgets/peerpal_save_button.dart';

class CompletePageButton extends StatelessWidget {
  final bool isSaveButton;
  final AsyncCallback onPressed;

  const CompletePageButton(
      {Key? key, required this.isSaveButton, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isSaveButton) {
      return PeerPALSaveButton(
        onPressed: onPressed,
      );
    } else {
      return PeerPALNextButton(
        onPressed:  onPressed,
      );
    }
  }
}