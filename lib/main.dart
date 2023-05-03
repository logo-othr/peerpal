import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activity/data/repository/activity_reminder_repository.dart';
import 'package:peerpal/activity/data/repository/location_repository.dart';
import 'package:peerpal/activity/domain/data/repository/activity_repository.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
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

class App extends StatefulWidget {
  App({
    Key? key,
  }) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
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
        ),
        RepositoryProvider.value(
          value: sl<LocationRepository>(),
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
