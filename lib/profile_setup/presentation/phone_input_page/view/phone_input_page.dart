import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/data/support_videos/resources/support_video_links.dart';
import 'package:peerpal/app/domain/support_videos/support_video_enum.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:peerpal/profile_setup/presentation/phone_input_page/cubit/phone_input_cubit.dart';
import 'package:peerpal/profile_setup/presentation/phone_input_page/view/phone_input_content.dart';
import 'package:peerpal/setup.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/support_video_dialog.dart';

class PhoneInputPage extends StatelessWidget {
  final bool isInFlowContext;

  PhoneInputPage({required this.isInFlowContext});

  static MaterialPage<void> page(
      {required bool isInFlowContext, required String pastPhone}) {
    return MaterialPage<void>(
        child: PhoneInputPage(
      isInFlowContext: isInFlowContext,
    ));
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
            return PhoneInputCubit(
                context.read<AppUserRepository>(), sl<GetAuthenticatedUser>())
              ..loadData();
          },
          child: PhoneNumberContent(
            isInFlowContext: isInFlowContext,
          ),
        ),
      ),
    );
  }
}
