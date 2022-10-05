import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activity/data/repository/activity_reminder_repository.dart';
import 'package:peerpal/activity/data/repository/activity_repository.dart';
import 'package:peerpal/app/bloc_observer.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/discover/data/repository/app_user_repository.dart';
import 'package:peerpal/setup.dart';

import 'app/app.dart';

Future<void> main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  setupTimeZones();
  await setupFirebase();
  await setupDependencies();
  await setupAuthentication();
  runApp(App());
}

class App extends StatelessWidget {
  App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: sl<AppUserRepository>(),
        ),
        RepositoryProvider.value(
          value: sl<ChatRepository>(),
        ),
        RepositoryProvider.value(
          value: sl<AuthenticationRepository>(),
        ),
        RepositoryProvider.value(
          value: sl<AuthenticationRepository>(),
        ),
        RepositoryProvider.value(
          value: sl<ActivityReminderRepository>(),
        ),
        RepositoryProvider.value(
          value: sl<ActivityRepository>(),
        )
      ],
      child: BlocProvider(
        create: (_) => AppBloc(
          authenticationRepository: sl<AuthenticationRepository>(),
        ),
        child: const AppView(),
      ),
    );
  }
}
