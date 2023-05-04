import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/data/support_videos/resources/support_video_links.dart';
import 'package:peerpal/app/domain/support_videos/support_video_enum.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/authentication/presentation/presentation.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/support_video_dialog.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("PeerPAL",
          hasBackButton: true,
          actionButtonWidget: CustomSupportVideoDialog(
              supportVideo:
                  SupportVideos.links[VideoIdentifier.settings_profile]!)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => SignupCubit(context.read<AuthenticationRepository>()),
          child: const SignUpForm(),
        ),
      ),
    );
  }
}
