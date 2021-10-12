import 'package:enum_to_string/enum_to_string.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/discover_wizard_flow/pages/discover_age/cubit/discover_age_cubit.dart';
import 'package:peerpal/discover_wizard_flow/pages/discover_communication/cubit/discover_communication_cubit.dart';
import 'package:peerpal/discover_wizard_flow/pages/discover_location/cubit/discover_location_cubit.dart';
import 'package:peerpal/repository/models/user_information.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_from_to_age_picker.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/custom_toggle_button.dart';
import 'package:peerpal/widgets/peerpal_next_button.dart';
import 'package:peerpal/widgets/peerpal_save_button.dart';

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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: CustomToggleButton(
                            text: communicationType.toUIString,
                            textColor: Colors.white,
                            height: 45,
                            width: 200,
                            onPressed: () {
                              if (state.selectedCommunicationTypes
                                  .contains(communicationType)) {
                                context
                                    .read<DiscoverCommunicationCubit>()
                                    .removeCommunication(communicationType);
                              } else {
                                context
                                    .read<DiscoverCommunicationCubit>()
                                    .addCommunication(communicationType);
                              }
                            },
                            active: state.selectedCommunicationTypes
                                .contains(communicationType),
                          ),
                        ),
                    ],
                  ),
                  Spacer(),
                  BlocBuilder<DiscoverCommunicationCubit,
                      DiscoverCommunicationState>(builder: (context, state) {
                    if (state is DiscoverCommunicationPosting) {
                      return const CircularProgressIndicator();
                    } else if (isInFlowContext) {
                      return PeerPALSaveButton(
                        onPressed: () async =>
                            updateCommunication(state, context),
                      );
                    } else {
                      return PeerPALNextButton(
                        onPressed: () async =>
                            updateCommunication(state, context),
                      );
                    }
                  }),
                ],
              ),
            ),
          );
        }));
  }

  Future<void> updateCommunication(
      DiscoverCommunicationState state, BuildContext context) async {
    if (isInFlowContext) {
      await context.read<DiscoverCommunicationCubit>().postCommunications();
      context.flow<UserInformation>().complete((s) => s.copyWith(
          discoverCommunicationPreferences: state.selectedCommunicationTypes));
    } else {
      await context.read<DiscoverCommunicationCubit>().postCommunications();
      Navigator.pop(context);
    }
  }
}
