import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/data/resources/colors.dart';
import 'package:peerpal/profile_setup/presentation/age_input_page/view/age_input_page.dart';
import 'package:peerpal/profile_setup/presentation/name_input_page/view/username_page.dart';
import 'package:peerpal/profile_setup/presentation/phone_input_page/view/phone_input_page.dart';
import 'package:peerpal/profile_setup/presentation/profile_overview/cubit/profile_overview_cubit.dart';
import 'package:peerpal/profile_setup/presentation/profile_picture_input_page/view/profile_picture_input_page.dart';
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
                                      width: 1,
                                      color: PeerPALAppColor.secondaryColor),
                                  bottom: BorderSide(
                                      width: 1,
                                      color: PeerPALAppColor.secondaryColor))),
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
                                          color: PeerPALAppColor.primaryColor,
                                          width: 4.0,
                                        ),
                                      ),
                                      child: _AvatarBox(link: text.data)),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: TextButton(
                                      onPressed: () async =>
                                          await _setProfilPick(context),
                                      style: TextButton.styleFrom(
                                        minimumSize: const Size(50, 15),
                                        backgroundColor: Colors.transparent,
                                        padding: const EdgeInsets.all(2),
                                      ),
                                      child: CustomPeerPALHeading3(
                                          text: 'Profilbild ändern',
                                          color:
                                              PeerPALAppColor.secondaryColor)),
                                )
                              ],
                            ),
                          )),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _ChangeName(name: state.appUserInformation.name!),
                        _ChangeAge(
                            age: state.appUserInformation.age.toString()),
                        _ChangePhonenumber(
                            phonenumber: state.appUserInformation.phoneNumber
                                .toString()),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _FinishButton()
              ],
            ),
          ),
        );
      } else {
        return CircularProgressIndicator();
      }
    });
  }

  Future<Set<void>> _setProfilPick(BuildContext context) async {
    return {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ProfilePictureInputPage(isInFlowContext: false)),
      ),
      setState(
        () {
          context.read<ProfileOverviewCubit>().loadData();
        },
      )
    };
  }
}

class _AvatarBox extends StatelessWidget {
  const _AvatarBox({Key? key, required this.link}) : super(key: key);
  final String? link;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 70,
      backgroundColor: Colors.white,
      child: ClipOval(
        child: (link == null || link!.isEmpty)
            ? Icon(
                Icons.account_circle,
                size: 140.0,
                color: Colors.grey,
              )
            : CachedNetworkImage(
                imageUrl: link!,
                height: 140,
                width: 140,
                fit: BoxFit.cover,
                errorWidget: (context, object, stackTrace) {
                  return const Icon(
                    Icons.account_circle,
                    size: 140.0,
                    color: Colors.grey,
                  );
                },
              ),
      ),
    );
  }
}

class _FinishButton extends StatelessWidget {
  const _FinishButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        child: CustomPeerPALButton(
          text: 'Fertig',
          onPressed: () => Navigator.pop(context),
        ));
  }
}

class _ChangePhonenumber extends StatelessWidget {
  const _ChangePhonenumber({
    Key? key,
    required this.phonenumber,
  }) : super(key: key);

  final String phonenumber;

  @override
  Widget build(BuildContext context) {
    return CustomSingleTable(
        heading: 'TELEFONNUMMER',
        text: phonenumber,
        isArrowIconVisible: true,
        onPressed: () async => {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PhoneInputPage(isInFlowContext: false)),
              ).then(
                  (value) => context.read<ProfileOverviewCubit>().loadData()),
            });
  }
}

class _ChangeAge extends StatelessWidget {
  const _ChangeAge({
    Key? key,
    required this.age,
  }) : super(key: key);

  final String age;

  @override
  Widget build(BuildContext context) {
    return CustomSingleTable(
        heading: 'ALTER',
        text: age,
        isArrowIconVisible: true,
        onPressed: () async => {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AgeInputPage(isInFlowContext: false)),
              ).then((value) => context.read<ProfileOverviewCubit>().loadData())
            });
  }
}

class _ChangeName extends StatelessWidget {
  const _ChangeName({Key? key, required this.name}) : super(key: key);

  final String? name;

  @override
  Widget build(BuildContext context) {
    return CustomSingleTable(
        heading: "Name",
        text: name!,
        isArrowIconVisible: true,
        onPressed: () async => {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        UsernamePage(isInFlowContext: false, pastName: name!)),
              ).then(
                  (value) => context.read<ProfileOverviewCubit>().loadData()),
            });
  }
}
