import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/peerpal_user/domain/peerpal_user.dart';
import 'package:peerpal/profile_setup/presentation/profile_overview/view/profile_overview_page.dart';
import 'package:peerpal/profile_setup/presentation/profile_picture_input_page/cubit/profile_picture_cubit.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class ProfilePictureInputContent extends StatelessWidget {
  final bool isInFlowContext;

  ProfilePictureInputContent({Key? key, required this.isInFlowContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              CustomPeerPALHeading1('Nimm ein Foto von dir auf'),
              const Spacer(),
              InkWell(
                onTap: () async => context
                    .read<ProfilePictureCubit>()
                    .pickProfilePictureFromGallery(),
                customBorder: new CircleBorder(),
                child: Container(child: _Avatar()),
              ),
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
              _Checkbox(isInFlowContext),
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

class _Avatar extends StatelessWidget {
  const _Avatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePictureCubit, ProfilePictureState>(
        builder: (context, state) {
      return new FutureBuilder(
          future: context.read<ProfilePictureCubit>().getProfilePicturePath(),
          initialData: null,
          builder: (BuildContext context, AsyncSnapshot<String?> text) {
            if (state is ProfilePictureInitial ||
                state is ProfilePicturePosted) {
              var imageURL = text.data;

              if (imageURL == '') {
                return Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primaryColor,
                        width: 4.0,
                      ),
                    ),
                    child: Icon(
                      Icons.account_circle,
                      size: 140,
                      color: Colors.grey,
                    ));
              }
              //var imageURL = null; // ToDo: Stop using flow state as a source
              if (imageURL != null && imageURL.isNotEmpty && imageURL != '') {
                return Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(imageURL),
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryColor,
                      width: 4.0,
                    ),
                  ),
                );
              }
            } else if (state is ProfilePicturePicked) {
              return Container(
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(File(state.profilePicture!.path)),
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryColor,
                    width: 4.0,
                  ),
                ),
              );
            } else if (state is ProfilePicturePosting) {
              return Container(
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryColor,
                    width: 4.0,
                  ),
                ),
                child: const CircularProgressIndicator(),
              );
            } else if (state is ProfilePicturePosting) {
              return Container(
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryColor,
                    width: 4.0,
                  ),
                ),
                child: const CircularProgressIndicator(),
              );
            }
            return Container(
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryColor,
                    width: 4.0,
                  ),
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  size: 110,
                  color: primaryColor,
                ));
          });
    });
  }
}

class _Checkbox extends StatelessWidget {
  final bool isInFlowContext;

  _Checkbox(this.isInFlowContext);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePictureCubit, ProfilePictureState>(
      builder: (context, state) {
        return CustomPeerPALButton2(
            text: 'Ich möchte kein Profilbild angeben',
            onPressed: () async {
              await context
                  .read<ProfilePictureCubit>()
                  .updateProfilePicture(null);

              if (isInFlowContext) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileOverviewPage()),
                );

                context
                    .flow<PeerPALUser>()
                    .complete((s) => s.copyWith(imagePath: ''));
              } else {
                Navigator.pop(context);
              }
            });
      },
    );
  }
}
