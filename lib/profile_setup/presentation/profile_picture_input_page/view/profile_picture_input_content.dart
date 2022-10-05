import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/data/resources/colors.dart';
import 'package:peerpal/discover/domain/peerpal_user.dart';
import 'package:peerpal/profile_setup/presentation/profile_overview/view/profile_overview_page.dart';
import 'package:peerpal/profile_setup/presentation/profile_picture_input_page/cubit/profile_picture_cubit.dart';
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
              _AvatarBox(),
              const Spacer(),
              BlocBuilder<ProfilePictureCubit, ProfilePictureState>(
                builder: (context, state) {
                  return CustomPeerPALButton(
                    text: isInFlowContext ? 'Weiter' : 'Speichern',
                    onPressed: (state is ProfilePicturePicked)
                        ? () async => updatePicture(
                              state,
                              context,
                            )
                        : null,
                  );
                },
              ),
              SizedBox(height: 10),
              _SaveAndClosePageWithoutProfilePictureButton(isInFlowContext),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updatePicture(
      ProfilePictureState state, BuildContext context) async {
    if (state is ProfilePicturePicked) {
      var profilePictureURL = await context
          .read<ProfilePictureCubit>()
          .updateProfilePicture(state.profilePicture);
      if (isInFlowContext) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileOverviewPage()),
        );
        context
            .flow<PeerPALUser>()
            .complete((s) => s.copyWith(imagePath: profilePictureURL));
      } else {
        Navigator.pop(context);
      }
    }
  }
}

class _AvatarBox extends StatelessWidget {
  const _AvatarBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async =>
          context.read<ProfilePictureCubit>().pickProfilePictureFromGallery(),
      customBorder: new CircleBorder(),
      child: Container(child: _Avatar()),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePictureCubit, ProfilePictureState>(
        builder: (context, state) {
      // ToDo: flatten conditional logic, refactor
      return new FutureBuilder(
          future: context.read<ProfilePictureCubit>().getProfilePicturePath(),
          initialData: null,
          builder:
              (BuildContext context, AsyncSnapshot<String?> imageURLSnapshot) {
            if (_isInitialOrPosted(state)) {
              var imageURL = imageURLSnapshot.data;
              if (imageURL == '') {
                return _EmptyImageContainer();
              }
              if (_imageLinkExists(imageURL)) {
                return _ImageContainerWithLink(
                    image: CachedNetworkImageProvider(imageURL!));
              }
            } else if (state is ProfilePicturePicked) {
              return _ImageContainerWithLink(
                  image: FileImage(File(state.profilePicture!.path)));
            } else if (state is ProfilePicturePosting) {
              return _LoadingAvatar();
            }
            return _EmptyAvatar();
          });
    });
  }

  _isInitialOrPosted(ProfilePictureState state) {
    return state is ProfilePictureInitial || state is ProfilePicturePosted;
  }

  bool _imageLinkExists(String? imageURL) =>
      imageURL != null && imageURL.isNotEmpty && imageURL != '';
}

class _EmptyAvatar extends StatelessWidget {
  const _EmptyAvatar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 150.0,
        height: 150.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: PeerPALAppColor.primaryColor,
            width: 4.0,
          ),
        ),
        child: Icon(
          Icons.camera_alt_outlined,
          size: 110,
          color: PeerPALAppColor.primaryColor,
        ));
  }
}

class _LoadingAvatar extends StatelessWidget {
  const _LoadingAvatar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      height: 150.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: PeerPALAppColor.primaryColor,
          width: 4.0,
        ),
      ),
      child: const CircularProgressIndicator(),
    );
  }
}

class _ImageContainerWithLink extends StatelessWidget {
  const _ImageContainerWithLink({Key? key, required this.image})
      : super(key: key);

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      height: 150.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: image,
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: PeerPALAppColor.primaryColor,
          width: 4.0,
        ),
      ),
    );
  }
}

class _EmptyImageContainer extends StatelessWidget {
  const _EmptyImageContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 150.0,
        height: 150.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: PeerPALAppColor.primaryColor,
            width: 4.0,
          ),
        ),
        child: Icon(
          Icons.account_circle,
          size: 140,
          color: Colors.grey,
        ));
  }
}

class _SaveAndClosePageWithoutProfilePictureButton extends StatelessWidget {
  final bool isInFlowContext;

  _SaveAndClosePageWithoutProfilePictureButton(this.isInFlowContext);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePictureCubit, ProfilePictureState>(
      builder: (context, state) {
        return CustomPeerPALButton2(
            text: 'Ich möchte kein Profilbild angeben',
            onPressed: () async {
              await _saveAndClosePageWithoutProfilePicture(context);
            });
      },
    );
  }

  Future<void> _saveAndClosePageWithoutProfilePicture(
      BuildContext context) async {
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
