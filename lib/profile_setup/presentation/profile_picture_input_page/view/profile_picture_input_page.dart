import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/injection.dart';
import 'package:peerpal/login_flow/persistence/authentication_repository.dart';
import 'package:peerpal/peerpal_user/data/repository/app_user_repository.dart';
import 'package:peerpal/peerpal_user/domain/usecase/get_user_usecase.dart';
import 'package:peerpal/profile_setup/presentation/profile_picture_input_page/cubit/profile_picture_cubit.dart';
import 'package:peerpal/profile_setup/presentation/profile_picture_input_page/view/profile_picture_input_content.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';

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
        appBar: CustomAppBar(
          "PeerPAL",
          hasBackButton: true,
        ),
        body: BlocProvider(
          create: (_) {
            return ProfilePictureCubit(
                context.read<AppUserRepository>(),
                context.read<AuthenticationRepository>(),
                sl<GetAuthenticatedUser>());
          },
          child: ProfilePictureInputContent(isInFlowContext: isInFlowContext),
        ),
      ),
    );
  }
}