import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/profile_wizard_flow/pages/name_input_page/cubit/name_input_cubit.dart';
import 'package:peerpal/profile_wizard_flow/pages/profile_overview/cubit/profile_overview_cubit.dart';
import 'package:peerpal/repository/models/user_information.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/custom_single_table.dart';

class ProfileOverviewContent extends StatefulWidget {
  @override
  _ProfileOverviewContentState createState() => _ProfileOverviewContentState();
}

class _ProfileOverviewContentState extends State<ProfileOverviewContent> {
  VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 40,
            ),
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(width: 1, color: secondaryColor),
                        bottom: BorderSide(width: 1, color: secondaryColor))),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: primaryColor,
                                width: 4.0,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 100,
                                color: primaryColor,
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: TextButton(
                            onPressed: onPressed,
                            style: TextButton.styleFrom(
                              minimumSize: const Size(50, 15),
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.all(2),
                            ),
                            child: CustomPeerPALHeading3('Profilbild ändern',
                                color: secondaryColor)),
                      )
                    ],
                  ),
                )),
            CustomSingleTable(
              heading: 'NAME',
              text: 'Hans',
              isArrowIconVisible: true,
              onPressed: () => {

              },
            ),
            CustomSingleTable(
                heading: 'ALTER',
                text: '32',
                isArrowIconVisible: true,
                onPressed: () => {}),
            CustomSingleTable(
                heading: 'TELEFONNUMMER',
                text: '012345567',
                isArrowIconVisible: true,
                onPressed: () => {}),
            const Spacer(),
            Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    CustomPeerPALButton(
                      text: 'Fertig',
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
