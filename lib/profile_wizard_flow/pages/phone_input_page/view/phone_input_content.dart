import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/profile_wizard_flow/pages/age_input_page/cubit/age_input_cubit.dart';
import 'package:peerpal/profile_wizard_flow/pages/phone_input_page/cubit/phone_input_cubit.dart';
import 'package:peerpal/repository/models/user_information.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class PhoneInputContent extends StatefulWidget {
  @override
  _PhoneInputContentState createState() => _PhoneInputContentState();
}

class _PhoneInputContentState extends State<PhoneInputContent> {
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
              children: [
                const SizedBox(height: 16.0),
                CustomPeerPALHeading1("Wie lautet deine Telefonnummer?"),
                const SizedBox(height: 30.0),
                _PhonenumberInputField(),
                const SizedBox(height: 8.0),
                _NextButton(),
                const SizedBox(height: 15.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PhonenumberInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneInputCubit, PhoneInputState>(
      buildWhen: (previous, current) =>
          previous.phoneNumber != current.phoneNumber,
      builder: (context, state) {
        return Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                style: TextStyle(fontSize: 22),
                key: const Key('phone_input_phone_number_field'),
                onChanged: (phoneNumber) =>
                    context.read<PhoneInputCubit>().phoneChanged(phoneNumber),
                maxLines: 1,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(30, 30, 0, 30),
                  labelText: 'Telefonnummer',
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
      },
    );
  }
}

class _NextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneInputCubit, PhoneInputState>(
      builder: (context, state) {
        if (state is AgeInputPosting) {
          return const CircularProgressIndicator();
        } else {
          return CustomPeerPALButton(
            text: 'Weiter',
            onPressed: () async {
              await context
                  .read<PhoneInputCubit>()
                  .updatePhoneNumber(state.phoneNumber);

              var phoneNumber = state.phoneNumber;
              context
                  .flow<UserInformation>()
                  .update((s) => s.copyWith(phoneNumber: phoneNumber));
            },
          );
        }
      },
    );
  }
}
