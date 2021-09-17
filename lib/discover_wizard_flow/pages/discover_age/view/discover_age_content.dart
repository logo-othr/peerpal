import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/discover_wizard_flow/pages/discover_age/cubit/discover_age_cubit.dart';
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
                  Container(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          CustomPeerPALButton(
                            text: 'Weiter',
                            onPressed: () => context
                                .read<DiscoverAgeCubit>()
                                .postAge(fromController.selectedItem,
                                    toController.selectedItem),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          );
        }));
  }
}
