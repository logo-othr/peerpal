import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/profile_setup/presentation/name_input_page/cubit/name_input_cubit.dart';

class UsernameFormField extends StatelessWidget {
  final bool isInFlowContext;
  final String pastName;

  const UsernameFormField({
    Key? key,
    required this.isInFlowContext,
    required this.pastName,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsernameCubit, UsernameState>(
      buildWhen: (previous, current) => _hasNameChanged(previous, current),
      builder: (context, state) {
        return TextFormField(
            maxLength: 30,
            initialValue: pastName,
            style: const TextStyle(fontSize: 22),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person),
              helperText: '',
              errorText: state.newUsername.invalid
                  ? 'Bitte geben sie Ihren Namen ein'
                  : null,
            ),
            key: const Key('name_selection_username_field'),
            onChanged: (username) => _updateUserName(context, username),
            keyboardType: TextInputType.name);
      },
    );
  }

  void _updateUserName(BuildContext context, String username) =>
      context.read<UsernameCubit>().nameChanged(username);

  bool _hasNameChanged(UsernameState previous, UsernameState current) =>
      previous.newUsername != current.newUsername;
}
