import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/data/support_videos/resources/support_video_links.dart';
import 'package:peerpal/app/domain/support_videos/support_video_enum.dart';
import 'package:peerpal/profile_setup/presentation/age_input_page/cubit/age_input_cubit.dart';
import 'package:peerpal/profile_setup/presentation/age_input_page/widgets/submit_age_button.dart';
import 'package:peerpal/widgets/age_picker.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/support_video_dialog.dart';

class AgeInputContent extends StatelessWidget {
  final bool isInFlowContext;

  const AgeInputContent({Key? key, required this.isInFlowContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Alter",
          hasBackButton: !isInFlowContext,
          actionButtonWidget: CustomSupportVideoDialog(
              supportVideo:
                  SupportVideos.links[VideoIdentifier.settings_profile]!)),
      body: _AgeForm(
        pageContext: context,
        isInFlowContext: isInFlowContext,
        key: key,
      ),
    );
  }
}

class _AgeForm extends StatelessWidget {
  final BuildContext pageContext;
  final bool isInFlowContext;

  const _AgeForm(
      {required this.pageContext, required this.isInFlowContext, Key? key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgeInputCubit, AgeInputState>(
      builder: (blocContext, state) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 40),
                  CustomPeerPALHeading1('Willkommen bei PeerPAL'),
                  const SizedBox(height: 40),
                  const _Logo(),
                  const SizedBox(height: 40),
                  CustomPeerPALHeading1('Wie alt bist du?'),
                  const SizedBox(height: 40),
                  new AgePicker(
                    hint: const Text('Alter auswählen'),
                    items: state.ages.map((el) => el.toString()).toList(),
                    value: state.selectedAge,
                    start: state.selectedAge,
                    onChanged: (value) => blocContext
                        .read<AgeInputCubit>()
                        .dataChanged((state.ages[value!])),
                  ),
                ],
              )),
              const Spacer(),
              (state is AgeInputPosting)
                  ? const CircularProgressIndicator()
                  : SubmitAgeButton(
                      pageContext: pageContext,
                      state: state,
                      isInFlowContext: isInFlowContext,
                      key: key),
            ],
          ),
        );
      },
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Container(
            padding: EdgeInsets.all(10),
            height: 120,
            width: 120,
            child: Image(image: AssetImage('assets/peerpal_logo.png'))));
  }
}
