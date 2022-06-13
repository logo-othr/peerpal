import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/profile_setup/pages/age_input_page/view/age_input_page.dart';
import 'package:peerpal/profile_setup/pages/name_input_page/view/name_input_page.dart';
import 'package:peerpal/profile_setup/pages/phone_input_page/view/phone_input_page.dart';
import 'package:peerpal/profile_setup/pages/profile_overview/cubit/profile_overview_cubit.dart';
import 'package:peerpal/profile_setup/pages/profile_picture_input_page/view/profile_picture_input_page.dart';
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
    return BlocBuilder<ProfileOverviewCubit, ProfileOverviewState>(
        builder: (context, state) {
      if (state is ProfileOverviewInitial) {
        return CircularProgressIndicator();
      } else if (state is ProfileOverviewLoaded) {
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
                  builder: (BuildContext context,
                          AsyncSnapshot<String?> text) =>
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  top: BorderSide(
                                      width: 1, color: secondaryColor),
                                  bottom: BorderSide(
                                      width: 1, color: secondaryColor))),
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                                        child: ClipOval(
                                          child: (text.data == null ||
                                                  text.data!.isEmpty)
                                              ? Icon(
                                                  Icons.account_circle,
                                                  size: 140.0,
                                                  color: Colors.grey,
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: text.data!,
                                                  height: 140,
                                                  width: 140,
                                                  fit: BoxFit.cover,
                                                  errorWidget: (context, object,
                                                      stackTrace) {
                                                    return const Icon(
                                                      Icons.account_circle,
                                                      size: 140.0,
                                                      color: Colors.grey,
                                                    );
                                                  },
                                                ),
                                        ),
                                      )),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: TextButton(
                                      onPressed: () async => {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfilePictureInputPage(
                                                          isInFlowContext:
                                                              false)),
                                            ),
                                            setState(
                                              () {
                                                context
                                                    .read<
                                                        ProfileOverviewCubit>()
                                                    .loadData();
                                              },
                                            )
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
                          )),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomSingleTable(
                            heading: "Name",
                            text: state.appUserInformation.name!,
                            isArrowIconVisible: true,
                            onPressed: () async => {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NameInputPage(
                                            isInFlowContext: false,
                                            pastName: state
                                                .appUserInformation.name!)),
                                  ).then((value) => context
                                      .read<ProfileOverviewCubit>()
                                      .loadData()),
                                }),
                        CustomSingleTable(
                            heading: 'ALTER',
                            text: state.appUserInformation.age.toString(),
                            isArrowIconVisible: true,
                            onPressed: () async => {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AgeInputPage(
                                            isInFlowContext: false)),
                                  ).then((value) => context
                                      .read<ProfileOverviewCubit>()
                                      .loadData())
                                }),
                        CustomSingleTable(
                            heading: 'TELEFONNUMMER',
                            text:
                                state.appUserInformation.phoneNumber.toString(),
                            isArrowIconVisible: true,
                            onPressed: () async => {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PhoneInputPage(
                                            isInFlowContext: false,
                                            pastPhone: state
                                                .appUserInformation.phoneNumber
                                                .toString())),
                                  ).then((value) => context
                                      .read<ProfileOverviewCubit>()
                                      .loadData()),
                                }),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                    color: Colors.transparent,
                    child: CustomPeerPALButton(
                      text: 'Fertig',
                      onPressed: () => Navigator.pop(context),
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
