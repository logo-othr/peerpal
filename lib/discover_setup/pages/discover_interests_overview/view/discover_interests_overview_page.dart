import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/data/support_videos/resources/support_video_links.dart';
import 'package:peerpal/app/domain/support_videos/support_video_enum.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:peerpal/discover_setup/pages/discover_interests_overview/cubit/discover_interests_overview_cubit.dart';
import 'package:peerpal/discover_setup/pages/discover_interests_overview/view/discover_interests_overview_content.dart';
import 'package:peerpal/setup.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/support_video_dialog.dart';

class DiscoverInterestsOverviewPage extends StatelessWidget {
  static MaterialPage<void> page() {
    return MaterialPage<void>(child: DiscoverInterestsOverviewPage());
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
          value: DiscoverInterestsOverviewCubit(
              context.read<AppUserRepository>(), sl<GetAuthenticatedUser>())
            ..loadData(),
          child: DiscoverInterestsOverviewContent(),
        ),
      ),
    );
  }
}
