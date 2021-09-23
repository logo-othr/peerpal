import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/app.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/login_flow/routes.dart';
import 'package:peerpal/repository/app_user_repository.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required AppUserRepository appUserRepository,
  })  : _appUserRepository = appUserRepository,
        super(key: key);

  final AppUserRepository _appUserRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _appUserRepository,
      child: BlocProvider(
        create: (_) => AppBloc(
          appUserRepository: _appUserRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: primaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.fromLTRB(30, 20, 0, 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: primaryColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: primaryColor,
                  width: 3,
                )),
          )),
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
