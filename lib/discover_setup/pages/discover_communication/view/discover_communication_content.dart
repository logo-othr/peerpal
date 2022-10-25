import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/cubit/discover_communication_cubit.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/enum/communication_type.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/custom_toggle_button.dart';
import 'package:peerpal/widgets/peerpal_complete_page_button.dart';

class DiscoverCommunicationContent extends StatelessWidget {
  final bool isInFlowContext;

  DiscoverCommunicationContent({Key? key, required this.isInFlowContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var hasBackButton = isInFlowContext;
    return Scaffold(
        appBar: CustomAppBar(
          'Kommunikation',
          hasBackButton: hasBackButton,
        ),
        body:
            BlocBuilder<DiscoverCommunicationCubit, DiscoverCommunicationState>(
                builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  CustomPeerPALHeading1("Bevorzugte Kommunikationsart"),
                  Spacer(),
                  Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      for (CommunicationType communicationType
                          in state.communicationTypes)
                        _CommunicationTypeButton(
                          communicationType: communicationType,
                          onPressed: () => context
                              .read<DiscoverCommunicationCubit>()
                              .toggleCommunicationType(communicationType),
                          isActive: state.selectedCommunicationTypes
                              .contains(communicationType),
                        ),
                    ],
                  ),
                  Spacer(),
                  (state is DiscoverCommunicationPosting)
                      ? const CircularProgressIndicator()
                      : CompletePageButton(
                          isSaveButton: isInFlowContext,
                          onPressed: () async {
                            _update(state, context);
                          }),
                ],
              ),
            ),
          );
        }));
  }

  Future<void> _update(
      DiscoverCommunicationState state, BuildContext context) async {
    if (isInFlowContext) {
      await context.read<DiscoverCommunicationCubit>().postData();
      context.flow<PeerPALUser>().complete((s) => s.copyWith(
          discoverCommunicationPreferences: state.selectedCommunicationTypes));
    } else {
      await context.read<DiscoverCommunicationCubit>().postData();
      Navigator.pop(context);
    }
  }
}

class _CommunicationTypeButton extends StatelessWidget {
  final CommunicationType communicationType;
  final VoidCallback onPressed;
  final bool isActive;

  const _CommunicationTypeButton(
      {Key? key,
      required this.communicationType,
      required this.onPressed,
      required this.isActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: CustomToggleButton(
          text: communicationType.toUIString,
          textColor: Colors.white,
          height: 45,
          width: 200,
          onPressed: onPressed,
          active: isActive),
    );
  }
}
