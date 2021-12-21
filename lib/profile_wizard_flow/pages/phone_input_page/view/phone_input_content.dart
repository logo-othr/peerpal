import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/profile_wizard_flow/pages/age_input_page/cubit/age_input_cubit.dart';
import 'package:peerpal/profile_wizard_flow/pages/phone_input_page/cubit/phone_input_cubit.dart';
import 'package:peerpal/profile_wizard_flow/pages/phone_input_page/models/phonenum_model.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class PhoneInputContent extends StatelessWidget {

  final bool isInFlowContext;

  PhoneInputContent({Key? key, required this.isInFlowContext})
      : super(key: key);

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<PhoneInputCubit, PhoneInputState>(
      listener: (context, state) {
        if (state is PhoneInputError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                  content: Text((state.message.isEmpty
                      ? "Fehler beim Speichern."
                      : state.message))),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16.0),
                CustomPeerPALHeading1("Wie lautet deine Telefonnummer?"),
                const SizedBox(height: 30.0),
                _PhonenumberInputField(isInFlowContext),
                const SizedBox(height: 8.0),
                _NextButton(isInFlowContext),
                const SizedBox(height: 15.0),
                _Checkbox(isInFlowContext),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PhonenumberInputField extends StatelessWidget {
  _PhonenumberInputField(bool isInFlowContext);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneInputCubit, PhoneInputState>(
      buildWhen: (previous, current) =>
          previous.phoneNumber != current.phoneNumber,
      builder: (context, state) {

        String? errorText = "";
        var errorState = state.phoneNumber.error;
        switch (errorState) {
          case PhoneError.toLong:
            errorText = "länge einer gültigen Telefonnummer überschritten";
            break;
          case PhoneError.toShort:
            errorText = "Länge einer gültigen Telefennummer unterschritten";
            break;
          default:
            errorText = null;
            break;
        }
        return new FutureBuilder(future: context.read<PhoneInputCubit>().currentPhoneNumber(),
        initialData: state.phoneNumber.value,
        builder:(BuildContext context, AsyncSnapshot<String?>text){
        return Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
              child: TextFormField(
                //discuss
                initialValue: text.data,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                style: const TextStyle(fontSize: 22),
                key: const Key('phone_input_phone_number_field'),
                onChanged: (phoneNumber) =>
                    context.read<PhoneInputCubit>().phoneChanged(phoneNumber),
                maxLines: 1,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(30, 30, 0, 30),
                  labelText: text.data,
                  errorText: state.phoneNumber.invalid ? errorText : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: primaryColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: primaryColor,
                        width: 3,
                      )),
                ),
              ),
            ),
          ),
        );
            }
        );}
      );
  }
}

class _NextButton extends StatelessWidget {

  final bool isInFlowContext;

  _NextButton(this.isInFlowContext);


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneInputCubit, PhoneInputState>(
      builder: (context, state) {
        if (state is AgeInputPosting) {
          return const CircularProgressIndicator();
        } else {
          return CustomPeerPALButton(
            text: 'Weiter',
            onPressed: !state.phoneNumber.invalid ? () async {
                await context
                    .read<PhoneInputCubit>()
                    .updatePhoneNumber(state.phoneNumber.value);

              var phoneNumber = state.phoneNumber;
              print(state.phoneNumber.invalid);
              if (isInFlowContext) {
                context
                    .flow<PeerPALUser>()
                    .update((s) => s.copyWith(phoneNumber: phoneNumber.value));
              } else {
                Navigator.pop(context);
              }

            } : null,
          );
        }
      },
    );
  }
}

class _Checkbox extends StatelessWidget {

  final bool isInFlowContext;

  _Checkbox(this.isInFlowContext);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneInputCubit, PhoneInputState>(
      builder: (context, state) {
          return  CustomPeerPALButton2(
            text: 'Ich möchte keine Telefonnummer angeben',
            onPressed: () async {

              if (isInFlowContext) {
                context.flow<PeerPALUser>().update((s) => s.copyWith(phoneNumber: 'Keine Angabe'));;
              } else {
                Navigator.pop(context);
              }

            },
          );

      },
    );
  }
}
