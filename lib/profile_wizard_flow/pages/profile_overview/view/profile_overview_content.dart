import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/profile_wizard_flow/pages/age_input_page/view/age_input_page.dart';
import 'package:peerpal/profile_wizard_flow/pages/name_input_page/view/name_input_page.dart';
import 'package:peerpal/profile_wizard_flow/pages/phone_input_page/view/phone_input_page.dart';
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
                onPressed: () async => {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NameInputPage(isInFlowContext: false)),
                  )
                }
            ),
            CustomSingleTable(
                heading: 'ALTER',
                text: '32',
                isArrowIconVisible: true,
                onPressed: () async => {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AgeInputPage(isInFlowContext: false)),
                  )
                }),
            CustomSingleTable(
                heading: 'TELEFONNUMMER',
                text: '012345567',
                isArrowIconVisible: true,
                onPressed: () async => {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PhoneInputPage(isInFlowContext: false)),
                      )
                    }),
            const Spacer(),
            Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    CustomPeerPALButton(
                      text: 'Fertig',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
