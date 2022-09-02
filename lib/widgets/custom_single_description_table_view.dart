import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

import '../data/resources/colors.dart';

// ignore: must_be_immutable
class CustomSingleDescriptionTable extends StatelessWidget {
  String? heading;
  String? description;
  bool? isEditingModus = false;
  VoidCallback? onPressed;
  TextEditingController? textEditingController;

  CustomSingleDescriptionTable(
      {this.heading,
      this.description,
      this.onPressed,
      this.isEditingModus,
      this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                child: CustomPeerPALHeading3(
                    text: heading!, color: PeerPALAppColor.secondaryColor),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                child: TextField(
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  readOnly: isEditingModus! ? false : true,
                  style: TextStyle(fontSize: 15),
                  controller: textEditingController,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.only(left: 35, top: 35, right: 35),
                    hintMaxLines: 3,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: description,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
