import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/data/support_videos/resources/support_video_links.dart';
import 'package:peerpal/app/domain/support_videos/support_video_enum.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:peerpal/profile_setup/presentation/profile_overview/cubit/profile_overview_cubit.dart';
import 'package:peerpal/profile_setup/presentation/profile_overview/view/profile_overview_content.dart';
import 'package:peerpal/setup.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/support_video_dialog.dart';

class ProfileOverviewPage extends StatelessWidget {
  static MaterialPage<void> page() {
    return MaterialPage<void>(child: ProfileOverviewPage());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: CustomAppBar("Überblick",
            hasBackButton: false,
            actionButtonWidget: CustomSupportVideoDialog(
                supportVideo:
                    SupportVideos.links[VideoIdentifier.settings_profile]!)),
        body: BlocProvider.value(
          value: ProfileOverviewCubit(
              context.read<AppUserRepository>(), sl<GetAuthenticatedUser>())
            ..loadData(),
          child: ProfileOverviewContent(),
        ),
      ),
    );
  }
}
