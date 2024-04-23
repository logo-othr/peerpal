import 'package:flutter/cupertino.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class CustomCupertinoSearchBar extends StatelessWidget {
  String? heading = "";
  bool enabled;
  TextEditingController searchBarController;
  FocusNode? focusNode;

  CustomCupertinoSearchBar(
      {this.heading,
      required this.searchBarController,
      this.enabled = true,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heading == null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: CustomPeerPALHeading1(heading!),
                ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: CupertinoSearchTextField(
              focusNode: focusNode,
              enabled: enabled,
              controller: searchBarController,
              placeholder: "Suchen",
            ),
          )
        ],
      ),
    );
  }
}
