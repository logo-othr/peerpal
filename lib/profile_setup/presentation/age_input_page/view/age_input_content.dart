import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/data/support_videos/resources/support_video_links.dart';
import 'package:peerpal/app/domain/support_videos/support_video_enum.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/profile_setup/presentation/age_input_page/cubit/age_input_cubit.dart';
import 'package:peerpal/widgets/age_picker.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/peerpal_complete_page_button.dart';
import 'package:peerpal/widgets/support_video_dialog.dart';

class AgeInputContent extends StatelessWidget {
  final bool isInFlowContext;

  const AgeInputContent({Key? key, required this.isInFlowContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar("Alter",
            hasBackButton: _isBackButtonRequired(),
            actionButtonWidget: CustomSupportVideoDialog(
                supportVideo:
                    SupportVideos.links[VideoIdentifier.settings_profile]!)),
        body: BlocBuilder<AgeInputCubit, AgeInputState>(
            buildWhen: (previous, current) =>
                previous.selectedAge != current.selectedAge,
            builder: (context, state) {
              return FutureBuilder(
                  future: context.read<AgeInputCubit>().currentAge(),
                  initialData: 14,
                  builder: (BuildContext context, AsyncSnapshot<int?> text) {
                    return _BuildCenterPage(
                      state: state,
                      text: text,
                      context: context,
                      isInFlowContext: isInFlowContext,
                      key: key,
                    );
                  });
            }));
  }

  bool _isBackButtonRequired() => (isInFlowContext) ? false : true;

  Future<void> _update(AgeInputState state, BuildContext context) async {
    if (isInFlowContext) {
      await context.read<AgeInputCubit>().postData();
      context
          .flow<PeerPALUser>()
          .update((s) => s.copyWith(age: state.selectedAge));
    } else {
      await context.read<AgeInputCubit>().postData();
      Navigator.pop(context);
    }
  }
}

class _SpacerBox extends StatelessWidget {
  const _SpacerBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 40,
    );
  }
}

class _PeerPALLogo extends StatelessWidget {
  const _PeerPALLogo({
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

class _NextButton extends AgeInputContent {
  final AgeInputState state;
  final BuildContext context;

  const _NextButton(
      {required this.state,
      required this.context,
      required bool isInFlowContext,
      Key? key})
      : super(isInFlowContext: isInFlowContext, key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
      child: CompletePageButton(
          isSaveButton: isInFlowContext,
          onPressed: () async {
            _update(state, context);
          }),
    );
  }
}

class _BuildCenterPage extends AgeInputContent {
  final AgeInputState state;
  final AsyncSnapshot<int?> text;
  final BuildContext context;

  const _BuildCenterPage(
      {required this.state,
      required this.text,
      required this.context,
      required bool isInFlowContext,
      Key? key})
      : super(isInFlowContext: isInFlowContext, key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: _PageContent(
                state: state, isInFlowContext: isInFlowContext, text: text),
          ),
          const Spacer(),
          (state is AgeInputPosting)
              ? const CircularProgressIndicator()
              : _NextButton(
                  state: state,
                  context: context,
                  isInFlowContext: isInFlowContext,
                  key: key),
        ],
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  const _PageContent({
    Key? key,
    required this.state,
    required this.isInFlowContext,
    required this.text,
  }) : super(key: key);

  final AgeInputState state;
  final bool isInFlowContext;
  final AsyncSnapshot<int?> text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const _SpacerBox(),
        CustomPeerPALHeading1('Willkommen bei PeerPAL'),
        const _SpacerBox(),
        const _PeerPALLogo(),
        const _SpacerBox(),
        CustomPeerPALHeading1('Wie alt bist du?'),
        const _SpacerBox(),
        new AgePicker(
            hint: const Text('Alter auswählen'),
            items: state.ages.map((el) => el.toString()).toList(),
            value: state.selectedAge,
            start: isInFlowContext ? state.selectedAge : text.data,
            onChanged: (value) {
              return context.read<AgeInputCubit>().dataChanged(
                    (state.ages[value!]),
                  );
            }),
      ],
    );
  }
}
