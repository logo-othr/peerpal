import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:peerpal/app/data/resources/colors.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/profile_setup/domain/phone_input_page/models/phonenum_model.dart';
import 'package:peerpal/profile_setup/presentation/phone_input_page/cubit/phone_input_cubit.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class PhoneNumberContent extends StatelessWidget {
  final bool isInFlowContext;

  PhoneNumberContent({Key? key, required this.isInFlowContext})
      : super(key: key);

  Widget build(BuildContext context) {
    return BlocBuilder<PhoneInputCubit, PhoneInputState>(
      builder: (context, state) {
        if (state is PhoneInputInitial) {
          return CircularProgressIndicator();
        } else {
          return PhoneNumberForm(
              isInFlowContext: isInFlowContext,
              currentPhoneNumber: state.currentUser.phoneNumber ?? '');
        }
      },
    );
  }
}

class PhoneNumberForm extends StatelessWidget {
  final bool isInFlowContext;
  final String currentPhoneNumber;

  const PhoneNumberForm(
      {Key? key,
      required this.isInFlowContext,
      required this.currentPhoneNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -1 / 3),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 28, 10, 12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _Headline(),
            _PhoneNumberInputField(isInFlowContext, currentPhoneNumber),
            _SaveButtons(isInFlowContext: isInFlowContext)
          ],
        ),
      ),
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline({
    Key? key,
  }) : super(key: key);
  final String headlineTxt = "Wie lautet deine Telefonnummer?";

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      alignment: Alignment.center,
      fit: BoxFit.scaleDown,
      child: CustomPeerPALHeading1(headlineTxt),
    );
  }
}

class _SaveButtons extends StatelessWidget {
  const _SaveButtons({
    Key? key,
    required this.isInFlowContext,
  }) : super(key: key);

  final bool isInFlowContext;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _SaveAndCloseButton(isInFlowContext),
      const SizedBox(height: 15),
      _SaveAndClosePageWithoutPhoneNumberButton(isInFlowContext)
    ]);
  }
}

class _PhoneNumberInputField extends StatelessWidget {
  const _PhoneNumberInputField(bool isInFlowContext, this.pastPhone);

  final String pastPhone;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneInputCubit, PhoneInputState>(
        buildWhen: (previous, current) =>
            previous.phoneNumber != current.phoneNumber,
        builder: (context, state) {
          String? errorText = _errorTxtForIncorrectPhoneLength(state);
          return Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                child: _PhoneTextfield(
                    pastPhone: pastPhone, errorText: errorText, state: state),
              ),
            ),
          );
        });
  }

  String? _errorTxtForIncorrectPhoneLength(PhoneInputState state) {
    String? errorText = "";
    var errorState = state.phoneNumber.error;
    const String toLong = "Die Nummer ist zu lang.";
    const String toShort = "Die Nummer ist zu kurz.";
    switch (errorState) {
      case PhoneError.toLong:
        errorText = toLong;
        break;
      case PhoneError.toShort:
        errorText = toShort;
        break;
      case PhoneError.minimum:
        errorText = '';
        break;
      default:
        errorText = null;
        break;
    }
    return errorText;
  }
}

class _PhoneTextfield extends StatelessWidget {
  const _PhoneTextfield({
    Key? key,
    required this.pastPhone,
    required this.errorText,
    required this.state,
  }) : super(key: key);

  final String pastPhone;
  final String? errorText;
  final PhoneInputState state;

  @override
  Widget build(BuildContext context) {
    const String inputExample = "Bsp: 01573243212323";
    const type = 'phone_input_phone_number_field';
    return TextFormField(
      maxLength: 15,
      initialValue: pastPhone,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      style: const TextStyle(fontSize: 22),
      key: const Key(type),
      onChanged: (phoneNumber) =>
          context.read<PhoneInputCubit>().phoneChanged(phoneNumber),
      maxLines: 1,
      decoration: _buildPhoneTxtInputDecoration(inputExample),
    );
  }

  InputDecoration _buildPhoneTxtInputDecoration(String inputExample) {
    return InputDecoration(
      labelText: inputExample,
      contentPadding: const EdgeInsets.fromLTRB(30, 30, 0, 30),
      errorText: state.phoneNumber.invalid ? errorText : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(
          color: PeerPALAppColor.primaryColor,
        ),
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            color: PeerPALAppColor.primaryColor,
            width: 3,
          )),
    );
  }
}

class _SaveAndCloseButton extends StatelessWidget {
  final bool isInFlowContext;

  const _SaveAndCloseButton(this.isInFlowContext);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneInputCubit, PhoneInputState>(
      builder: (context, state) {
        if (state.formValidationStatus == FormzStatus.submissionInProgress) {
          return const CircularProgressIndicator();
        } else {
          return CustomPeerPALButton(
            color: state.phoneNumber.invalid ? Colors.blueGrey : null,
            text: 'Weiter',
            onPressed: !state.phoneNumber.invalid
                ? () async {
                    await _saveAndClosePage(context, state);
                  }
                : null,
          );
        }
      },
    );
  }

  Future<void> _saveAndClosePage(
      BuildContext context, PhoneInputState state) async {
    await context
        .read<PhoneInputCubit>()
        .updatePhoneNumber(state.phoneNumber.value);

    var phoneNumber = state.phoneNumber;

    if (isInFlowContext) {
      context
          .flow<PeerPALUser>()
          .update((s) => s.copyWith(phoneNumber: phoneNumber.value));
    } else {
      Navigator.pop(context);
    }
  }
}

class _SaveAndClosePageWithoutPhoneNumberButton extends StatelessWidget {
  final bool isInFlowContext;
  final String buttonTxt = 'Ich möchte keine Telefonnummer angeben';

  const _SaveAndClosePageWithoutPhoneNumberButton(this.isInFlowContext);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneInputCubit, PhoneInputState>(
      builder: (context, state) {
        return CustomPeerPALButton2(
            text: buttonTxt,
            onPressed: () async {
              await _saveAndClosePageWithoutPhoneNumber(context);
            });
      },
    );
  }

  Future<void> _saveAndClosePageWithoutPhoneNumber(BuildContext context) async {
    await context.read<PhoneInputCubit>().updatePhoneNumber('');

    if (isInFlowContext) {
      context.flow<PeerPALUser>().update((s) => s.copyWith(phoneNumber: ''));
    } else {
      Navigator.pop(context);
    }
  }
}
