import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/bloc_observer.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/injection.dart';
import 'package:peerpal/login_flow/persistence/authentication_repository.dart';
import 'package:peerpal/notification_service.dart';
import 'package:peerpal/repository/activity_repository.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';

Future<void> _remoteNotificationBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message ${message.data}");
  print('onResume: $message');
  if (message.notification != null) {
    RemoteNotification remoteNotification = message.notification!;
    sl<NotificationService>().showNotification(
        0, remoteNotification.title ?? "", remoteNotification.body ?? "");
  }
  return;
}

Future<void> main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await init();
  sl<NotificationService>().startRemoteNotificationBackgroundHandler(
      _remoteNotificationBackgroundHandler);
  //PushNotificationService.configLocalNotification(); // migrated

  final authenticationRepository = sl<AuthenticationRepository>();
  await authenticationRepository.user.first;

  //await DebugHelper.createExampleUsers(appUserRepository: authenticationRepository, emailBase:  'pptestmailbase234', password: 'Abc12345678*');
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
