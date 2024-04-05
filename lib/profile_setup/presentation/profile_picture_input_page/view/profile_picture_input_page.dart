import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/data/support_videos/resources/support_video_links.dart';
import 'package:peerpal/app/domain/support_videos/support_video_enum.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:peerpal/profile_setup/presentation/profile_picture_input_page/cubit/profile_picture_cubit.dart';
import 'package:peerpal/profile_setup/presentation/profile_picture_input_page/view/profile_picture_input_content.dart';
import 'package:peerpal/setup.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/support_video_dialog.dart';

class ProfilePictureInputPage extends StatelessWidget {
  final bool isInFlowContext;

  ProfilePictureInputPage({required this.isInFlowContext});

  static MaterialPage<void> page({required bool isInFlowContext}) {
    return MaterialPage<void>(
        child: ProfilePictureInputPage(isInFlowContext: isInFlowContext));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: CustomAppBar("PeerPAL",
            hasBackButton: true,
            actionButtonWidget: CustomSupportVideoDialog(
                supportVideo:
                    SupportVideos.links[VideoIdentifier.settings_profile]!)),
        body: BlocProvider(
          create: (_) {
            return ProfilePictureCubit(
                context.read<AppUserRepository>(),
                context.read<AuthenticationRepository>(),
                sl<GetAuthenticatedUser>())
              ..loadData();
          },
          child: ProfilePictureInputContent(isInFlowContext: isInFlowContext),
        ),
      ),
    );
  }
}
