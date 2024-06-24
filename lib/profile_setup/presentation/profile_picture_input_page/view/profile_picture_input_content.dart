import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/discover_feed_v2/domain/peerpal_user.dart';
import 'package:peerpal/profile_setup/presentation/profile_overview/view/profile_overview_page.dart';
import 'package:peerpal/profile_setup/presentation/profile_picture_input_page/cubit/profile_picture_cubit.dart';
import 'package:peerpal/profile_setup/presentation/profile_picture_input_page/widgets/avatar.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class ProfilePictureInputContent extends StatelessWidget {
  final bool isInFlowContext;

  const ProfilePictureInputContent({Key? key, required this.isInFlowContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String headlineTxt = 'Nimm ein Foto von dir auf';
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              CustomPeerPALHeading1(headlineTxt),
              const Spacer(),
              _ImagePickerAvatar(),
              const Spacer(),
              BlocBuilder<ProfilePictureCubit, ProfilePictureState>(
                builder: (context, state) {
                  return CustomPeerPALButton(
                    text: isInFlowContext ? 'Weiter' : 'Speichern',
                    onPressed: (state is ProfilePicturePicked)
                        ? () async => _updatePicture(
                              state,
                              context,
                            )
                        : null,
                  );
                },
              ),
              SizedBox(height: 10),
              _SubmitWithoutPictureButton(isInFlowContext),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updatePicture(
      ProfilePictureState state, BuildContext context) async {
    if (state is ProfilePicturePicked) {
      // Upload the photo and update it in the database
      var profilePictureURL = await context
          .read<ProfilePictureCubit>()
          .updateProfilePicture(state.profilePicture);
      // Was the page opened in the context of the profile setup?
      if (isInFlowContext) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileOverviewPage()),
        );
        // Update the flow-object to continue the setup
        context
            .flow<PeerPALUser>()
            .complete((s) => s.copyWith(imagePath: profilePictureURL));
      } else {
        //if not then close the page
        Navigator.pop(context);
      }
    }
  }
}

class _ImagePickerAvatar extends StatelessWidget {
  const _ImagePickerAvatar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async =>
          context.read<ProfilePictureCubit>().pickProfilePictureFromGallery(),
      customBorder: new CircleBorder(),
      child: Container(child:
          BlocBuilder<ProfilePictureCubit, ProfilePictureState>(
              builder: (context, state) {
        if (state is ProfilePictureLoaded || state is ProfilePicturePosted) {
          String imageURL =
              context.read<ProfilePictureCubit>().getProfilePicturePath();
          return Avatar(avatarType: AvatarType.network, uri: imageURL);
        } else if (state is ProfilePicturePicked) {
          String imageURL = state.profilePicture!.path;
          return Avatar(avatarType: AvatarType.local, uri: imageURL);
        } else if (state is ProfilePicturePosting) {
          return Avatar(avatarType: AvatarType.loading, uri: "");
        } else
          return Avatar(avatarType: AvatarType.empty, uri: "");
      })),
    );
  }
}

class _SubmitWithoutPictureButton extends StatelessWidget {
  final bool isInFlowContext;

  _SubmitWithoutPictureButton(this.isInFlowContext);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePictureCubit, ProfilePictureState>(
      builder: (context, state) {
        return CustomPeerPALButton2(
            text: 'Ich möchte kein Profilbild angeben',
            onPressed: () async {
              await _submitWithoutPicture(context);
            });
      },
    );
  }

  Future<void> _submitWithoutPicture(BuildContext context) async {
    await context.read<ProfilePictureCubit>().updateProfilePicture(null);

    if (isInFlowContext) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileOverviewPage()),
      );

      context.flow<PeerPALUser>().complete((s) => s.copyWith(imagePath: ''));
    } else {
      Navigator.pop(context);
    }
  }
}
