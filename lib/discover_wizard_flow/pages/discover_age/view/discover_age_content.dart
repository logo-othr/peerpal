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

  @override
  Widget build(BuildContext context) {
    var hasBackButton = (isInFlowContext) ? false : true;
    return Scaffold(
      appBar: CustomAppBar(
        "Alter",
        hasBackButton: hasBackButton,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              CustomPeerPALHeading1("Alter"),
              SizedBox(
                height: 100,
              ),
              BlocBuilder<DiscoverAgeCubit, DiscoverAgeState>(
                  builder: (context, state) {
                return CustomFromToAgePicker(
                    fromMin: state.fromMinAge,
                    fromMax: state.fromMaxAge,
                    toMin: state.toMinAge,
                    toMax: state.toMaxAge);
              }),
              Spacer(),
              Container(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CustomPeerPALButton(text: "Weiter"),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
