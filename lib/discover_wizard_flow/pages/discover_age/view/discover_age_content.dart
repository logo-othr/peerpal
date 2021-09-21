import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/discover_wizard_flow/pages/discover_age/cubit/discover_age_cubit.dart';
import 'package:peerpal/repository/models/user_information.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_from_to_age_picker.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class DiscoverAgeContent extends StatelessWidget {
  final bool isInFlowContext;

  DiscoverAgeContent({Key? key, required this.isInFlowContext})
      : super(key: key);

  var fromController = FixedExtentScrollController();
  var toController = FixedExtentScrollController();

  @override
  Widget build(BuildContext context) {
    var hasBackButton = (isInFlowContext) ? false : true;
    return Scaffold(
        appBar: CustomAppBar(
          'Alter',
          hasBackButton: hasBackButton,
        ),
        body: BlocBuilder<DiscoverAgeCubit, DiscoverAgeState>(
            builder: (context, state) {
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
                  BlocBuilder<DiscoverAgeCubit, DiscoverAgeState>(
                    builder: (context, state) {
                      if (state is DiscoverAgePosting) {
                        return const CircularProgressIndicator();
                      } else {
                        if(isInFlowContext) {
                          return CustomPeerPALButton(
                            text: 'Weiter',
                            onPressed: () async {
                              await context
                                  .read<DiscoverAgeCubit>()
                                  .postAge(state.selctedFromAge, state.selectedToAge);

                              context
                                  .flow<UserInformation>()
                                  .update((s) => s.copyWith(discoverFromAge: state.selctedFromAge, discoverToAge: state.selectedToAge));
                            },
                          );
                        } else {
                          return CustomPeerPALButton(
                            text: 'Speichern',
                            onPressed: () async {
                              await context
                                  .read<DiscoverAgeCubit>()
                                  .postAge(state.selctedFromAge, state.selectedToAge);
                              Navigator.pop(context);
                            },
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
