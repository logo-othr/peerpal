import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/domain/support_videos/support_video_enum.dart';
import 'package:peerpal/data/resources/support_video_links.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/pages/discover_age/cubit/discover_age_cubit.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_from_to_age_picker.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/peerpal_complete_page_button.dart';
import 'package:peerpal/widgets/support_video_dialog.dart';

class DiscoverAgeContent extends StatefulWidget {
  final bool isInFlowContext;

  DiscoverAgeContent({Key? key, required this.isInFlowContext})
      : super(key: key);

  @override
  State<DiscoverAgeContent> createState() => _DiscoverAgeContentState();
}

class _DiscoverAgeContentState extends State<DiscoverAgeContent> {
  FixedExtentScrollController? fromController = FixedExtentScrollController();

  FixedExtentScrollController? toController = FixedExtentScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) async => fromController?.jumpToItem(
        await context.read<DiscoverAgeCubit>().getInitialFromAge(),
      ),
    );
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) async => toController?.jumpToItem(
        await context.read<DiscoverAgeCubit>().getInitialToAge(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var hasBackButton = (widget.isInFlowContext) ? false : true;
    return Scaffold(
        appBar: CustomAppBar('Alter',
            hasBackButton: hasBackButton,
            actionButtonWidget: CustomSupportVideoDialog(
                supportVideo: SupportVideos
                    .links[VideoIdentifier.settings_profile_tab]!)),
        body: BlocBuilder<DiscoverAgeCubit, DiscoverAgeState>(
            builder: (context, state) {
          var state = context.read<DiscoverAgeCubit>().state;
          return Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 40,
                  ),
                  CustomPeerPALHeading1('Alter'),
                  const SizedBox(
                    height: 100,
                  ),
                  CustomFromToAgePicker(
                    fromMin: state.fromMinAge,
                    fromMax: state.fromMaxAge,
                    toMin: state.toMinAge,
                    toMax: state.toMaxAge,
                    toController: toController,
                    fromController: fromController,
                  ),
                  const Spacer(),
                  (state is DiscoverAgePosting)
                      ? const CircularProgressIndicator()
                      : CompletePageButton(
                          isSaveButton: widget.isInFlowContext,
                          onPressed: () async {
                            _update(state, context);
                          }),
                ],
              ),
            ),
          );
        }));
  }

  Future<void> _update(DiscoverAgeState state, BuildContext context) async {
    if (widget.isInFlowContext) {
      await context.read<DiscoverAgeCubit>().postData();
      context.flow<PeerPALUser>().complete((s) => s.copyWith(
          discoverFromAge: state.selctedFromAge,
          discoverToAge: state.selectedToAge));
    } else {
      await context.read<DiscoverAgeCubit>().postData();
      Navigator.pop(context);
    }
  }
}
