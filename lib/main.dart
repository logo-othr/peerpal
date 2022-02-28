import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:peerpal/app/bloc_observer.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/injection.dart';
import 'package:peerpal/repository/activity_repository.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';

final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void configLocalNotification() {
  final AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  final IOSInitializationSettings initializationSettingsIOS =
      const IOSInitializationSettings();

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void showNotification(RemoteNotification remoteNotification) async {
  const NotificationDetails platformChannelSpecifics =
      const NotificationDetails(
          android: AndroidNotificationDetails(
            'app_notification',
            'app_notification_channel',
            'Channel for all app notifications',
            playSound: true,
            priority: Priority.high,
            importance: Importance.max,
          ),
          iOS: IOSNotificationDetails());

  print(remoteNotification);

  await flutterLocalNotificationsPlugin.show(
    0,
    remoteNotification.title,
    remoteNotification.body,
    platformChannelSpecifics,
    payload: 'Notification Payload',
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message ${message.data}");
  print('onResume: $message');
  if (message.notification != null) {
    showNotification(message.notification!);
  }
  return;
}

Future<void> _firebaseMessagingInAppHandler(RemoteMessage message) async {
  print("Handling in App message ${message.data}");
  print('onMessage: $message');
  if (message.notification != null) {
    showNotification(message.notification!);
  }
  return;
}

Future<void> _firebaseMessagingOnOpenAppHandler(RemoteMessage message) async {
  print("Handling on open App message ${message.data}");
  print('onLaunch: $message');
  if (message.notification != null) {
    showNotification(message.notification!);
  }
  return;
}

Future<void> main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  firebaseMessaging.requestPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(_firebaseMessagingInAppHandler);
  FirebaseMessaging.onMessageOpenedApp
      .listen(_firebaseMessagingOnOpenAppHandler);
  configLocalNotification();
  await init();

  final authenticationRepository = sl<AppUserRepository>();
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
          value: ActivityRepository(sl<SharedPreferences>()),
        )
      ],
      child: BlocProvider(
        create: (_) => AppBloc(
          appUserRepository: sl<AppUserRepository>(),
        ),
        child: const AppView(),
      ),
    );
  }
}
