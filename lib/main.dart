import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activity/data/repository/activity_reminder_repository.dart';
import 'package:peerpal/activity/data/repository/activity_repository.dart';
import 'package:peerpal/app/bloc_observer.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/injection.dart';
import 'package:peerpal/login_flow/persistence/authentication_repository.dart';
import 'package:peerpal/peerpal_user/data/repository/app_user_repository.dart';
import 'package:peerpal/tabview/domain/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'app/app.dart';

Future<void> main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await init();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Berlin'));
  final authenticationRepository = sl<AuthenticationRepository>();
  await authenticationRepository.user.first;
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
          value: ActivityRepository(sl<SharedPreferences>()), // ToDo: use SL
        ),
        RepositoryProvider.value(
          value: ActivityReminderRepository(
              prefs: sl<SharedPreferences>(),
              notificationService: sl<NotificationService>()), // ToDo: use SL
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
