import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/domain/support_videos/support_video_enum.dart';
import 'package:peerpal/data/resources/support_video_links.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:peerpal/profile_setup/presentation/name_input_page/cubit/name_input_cubit.dart';
import 'package:peerpal/profile_setup/presentation/name_input_page/view/name_input_content.dart';
import 'package:peerpal/setup.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/support_video_dialog.dart';

class NameInputPage extends StatelessWidget {
  final bool isInFlowContext;
  final String pastName;

  NameInputPage({required this.isInFlowContext, this.pastName = ''});

  static MaterialPage<void> page({required bool isInFlowContext}) {
    return MaterialPage<void>(
        child: NameInputPage(isInFlowContext: isInFlowContext));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: CustomAppBar('PeerPAL',
            hasBackButton: true,
            actionButtonWidget: CustomSupportVideoDialog(
                supportVideo: SupportVideos
                    .links[VideoIdentifier.settings_profile_tab]!)),
        body: BlocProvider(
          create: (_) {
            return NameInputCubit(
                context.read<AppUserRepository>(), sl<GetAuthenticatedUser>());
          },
          child: NameInputContent(
            isInFlowContext: isInFlowContext,
            pastName: pastName,
          ),
        ),
      ),
    );
  }
}
