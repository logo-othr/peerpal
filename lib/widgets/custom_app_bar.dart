import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activities/activity_overview_page/cubit/activity_overview_cubit.dart';
import 'package:peerpal/widgets/custom_dialog.dart';

import 'custom_peerpal_text.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;

  final Widget? actionButtonWidget;
  final hasBackButton;
  final VoidCallback? onBackButtonPressed;
  final VoidCallback? onActionButtonPressed;

  CustomAppBar(
    this.title, {
    this.hasBackButton = false,
    this.onBackButtonPressed,
    this.actionButtonWidget,
    this.onActionButtonPressed,
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
        actions: actionButtonWidget != null
            ? [
                GestureDetector(
                    onTap: onActionButtonPressed, child: actionButtonWidget!)
              ]
            : [],
        leading: hasBackButton
            ? Row(children: <Widget>[
                Container(
                  width: 30,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: onBackButtonPressed != null
                        ? onBackButtonPressed
                        : () {
                            Navigator.of(context).pop();
                          },
                  ),
                ),
                TextButton(
                  onPressed: onBackButtonPressed != null
                      ? onBackButtonPressed
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: CustomPeerPALText(
                    text: "Zurück",
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                )
              ])
            : null);
  }
}
