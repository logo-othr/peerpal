import 'package:flutter/material.dart';

import 'custom_peerpal_text.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;

  CustomAppBar(
    this.title, {
    Key? key,
  })  : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        title: Text(title),
        centerTitle: true,
        leadingWidth: 130,
        leading: Row(children: <Widget>[
          Container(
            width: 30,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: CustomPeerPALText(
              text: "Zurück",
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          )
        ]));
  }
}
