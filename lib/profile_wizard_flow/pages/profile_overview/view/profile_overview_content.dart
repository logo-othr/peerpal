import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/profile_wizard_flow/pages/age_input_page/view/age_input_page.dart';
import 'package:peerpal/profile_wizard_flow/pages/name_input_page/view/name_input_page.dart';
import 'package:peerpal/profile_wizard_flow/pages/phone_input_page/view/phone_input_page.dart';
import 'package:peerpal/profile_wizard_flow/pages/profile_picture_input_page/view/profile_picture_input_page.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/custom_single_table.dart';
import 'package:peerpal/profile_wizard_flow/pages/profile_overview/cubit/profile_overview_cubit.dart';

class ProfileOverviewContent extends StatefulWidget {
  @override
  _ProfileOverviewContentState createState() => _ProfileOverviewContentState();
}

class _ProfileOverviewContentState extends State<ProfileOverviewContent> {
  VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileOverviewCubit, ProfileOverviewState>(
        builder: (context, state) {
          if(state is ProfileOverviewInitial) {
            return CircularProgressIndicator();
          }
          else if(state is ProfileOverviewLoaded) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 40,
                    ),
                    new FutureBuilder(
                      future: context.read<ProfileOverviewCubit>().profilePicture(),
                      initialData: state.appUserInformation.imagePath!,
                      builder:(BuildContext context, AsyncSnapshot<String?>text)=>
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
                                            child: CircleAvatar(
                                              radius: 70,
                                              child:  ClipOval(
                                                child: Image.network(text.data!),
                                              ),
                                              backgroundColor: Colors.white,
                                            ),
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      child: TextButton(
                                          onPressed: () async => {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfilePictureInputPage(isInFlowContext: false)),
                                            ),
                                            setState((){
                                              context.read<ProfileOverviewCubit>().loadData();},)
                                          },
                                          style: TextButton.styleFrom(
                                            minimumSize: const Size(50, 15),
                                            backgroundColor: Colors.transparent,
                                            padding: const EdgeInsets.all(2),
                                          ),
                                          child: CustomPeerPALHeading3(
                                              text: 'Profilbild ändern',
                                              color: secondaryColor)),
                                    )
                                  ],
                                ),
                              )
                          ),
                    ),

                    new FutureBuilder(
                      future: context.read<ProfileOverviewCubit>().name(),
                      initialData: state.appUserInformation.name!,
                      builder:(BuildContext context, AsyncSnapshot<String?>text)=> CustomSingleTable(
                          heading: "Name",
                          text: text.data!,
                          isArrowIconVisible: true,
                          onPressed: () async => {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NameInputPage(isInFlowContext: false)),
                            ),
                            setState((){
                              context.read<ProfileOverviewCubit>().loadData();},)
                          }),),
                    new FutureBuilder(
                        future: context.read<ProfileOverviewCubit>().age(),
                        initialData: "12",
                        builder:(BuildContext context, AsyncSnapshot<String?>text)=> CustomSingleTable(
                            heading: 'ALTER',
                            text: text.data!,
                            isArrowIconVisible: true,
                            onPressed: () async => {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AgeInputPage(isInFlowContext: false)),
                              ),
                              setState((){
                                context.read<ProfileOverviewCubit>().loadData();
                              },
                              )
                            }
                        )
                    ),
                    new FutureBuilder(
                      future: context.read<ProfileOverviewCubit>().phoneNumber(),
                      initialData: state.appUserInformation.phoneNumber!,
                      builder:(BuildContext context, AsyncSnapshot<String?>text)=>
                          CustomSingleTable(
                              heading: 'TELEFONNUMMER',
                              text: text.data!,
                              isArrowIconVisible: true,
                              onPressed: () async => {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PhoneInputPage(isInFlowContext: false)),
                                ),
                                setState((){
                                  context.read<ProfileOverviewCubit>().loadData();
                                },
                                )
                              }
                          ),
                    ),
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
          } else {
            return CircularProgressIndicator();
          }

        });
  }
}
