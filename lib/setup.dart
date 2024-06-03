import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:peerpal/account_setup/data/app_reminder_notification_repository.dart';
import 'package:peerpal/account_setup/domain/weekly_reminder_usecase.dart';
import 'package:peerpal/activity/data/repository/firebase_activity_repository.dart';
import 'package:peerpal/activity/data/repository/local_activity_reminder_repository.dart';
import 'package:peerpal/activity/domain/repository/activity_reminder_repository.dart';
import 'package:peerpal/activity/domain/repository/activity_repository.dart';
import 'package:peerpal/activity/domain/usecase/calculate_upcoming_reminder_dates_usecase.dart';
import 'package:peerpal/activity/domain/usecase/has_ios_notification_permission_usecase.dart';
import 'package:peerpal/activity/domain/usecase/schedule_activity_reminder_usecase.dart';
import 'package:peerpal/activity/domain/usecase/update_created_activities_reminders_usecase.dart';
import 'package:peerpal/activity/domain/usecase/update_joined_activities_reminders_usecase.dart';
import 'package:peerpal/activity/presentation/activity_feed/bloc/activity_feed_bloc.dart';
import 'package:peerpal/activity/presentation/activity_requests/bloc/activity_request_list_bloc.dart';
import 'package:peerpal/activity/presentation/joined_activities/bloc/activity_joined_list_bloc.dart';
import 'package:peerpal/app/data/analytics/datasources/firebase_analytics_service.dart';
import 'package:peerpal/app/data/analytics/repository/firebase_analytics_repository.dart';
import 'package:peerpal/app/data/app_configuration_service.dart';
import 'package:peerpal/app/data/core/memory_cache.dart';
import 'package:peerpal/app/data/firestore/firestore_service.dart';
import 'package:peerpal/app/data/local_app_configuration_service.dart';
import 'package:peerpal/app/data/location/repository/local_location_repository.dart';
import 'package:peerpal/app/data/notification/device_token_service.dart';
import 'package:peerpal/app/data/notification/firebase_notification_service.dart';
import 'package:peerpal/app/domain/analytics/analytics_repository.dart';
import 'package:peerpal/app/domain/analytics/analytics_service.dart';
import 'package:peerpal/app/domain/core/cache.dart';
import 'package:peerpal/app/domain/location/location_repository.dart';
import 'package:peerpal/app/domain/notification/notification_service.dart';
import 'package:peerpal/app/domain/notification/usecase/start_remote_notifications.dart';
import 'package:peerpal/app_logger.dart';
import 'package:peerpal/authentication/domain/auth_service.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/authentication/persistence/firebase_auth_service.dart';
import 'package:peerpal/chat/domain/usecases/get_all_userchats.dart';
import 'package:peerpal/chat/domain/usecases/get_chat_requests_usecase.dart';
import 'package:peerpal/chat/domain/usecases/send_chat_message_usecase.dart';
import 'package:peerpal/chat/presentation/chat_request_list/cubit/chat_requests_cubit.dart';
import 'package:peerpal/chatv2/data/repository/chat_repository_firebase.dart';
import 'package:peerpal/chatv2/domain/core-usecases/cancel_friend_request.dart';
import 'package:peerpal/chatv2/domain/core-usecases/get_friend_list.dart';
import 'package:peerpal/chatv2/domain/core-usecases/get_sent_friend_requests.dart';
import 'package:peerpal/chatv2/domain/core-usecases/send_chat_request_response.dart';
import 'package:peerpal/chatv2/domain/core-usecases/send_friend_request.dart';
import 'package:peerpal/chatv2/domain/repositorys/chat_repository.dart';
import 'package:peerpal/chatv2/domain/usecases/get_chats.dart';
import 'package:peerpal/chatv2/domain/usecases/get_messages.dart';
import 'package:peerpal/chatv2/domain/usecases/get_user.dart';
import 'package:peerpal/chatv2/domain/usecases/send_message.dart';
import 'package:peerpal/chatv2/presentation/chatlist/cubit/chat_list_cubit.dart';
import 'package:peerpal/chatv2/presentation/chatroom/cubit/chatroom_cubit.dart';
import 'package:peerpal/chatv2/presentation/chatroom/widgets/friend_request_button/friend_request_cubit.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/data/repository/firebase_discover_repository.dart';
import 'package:peerpal/discover_feed/domain/repository/discover_repository.dart';
import 'package:peerpal/discover_feed/domain/usecase/find_peers.dart';
import 'package:peerpal/discover_feed/domain/usecase/find_user_by_name.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/data/local_communication_repository.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/repository/communication_repository.dart';
import 'package:peerpal/friends/data/firebase_friend_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'friends/domain/repository/friend_repository.dart';

@pragma('vm:entry-point')
Future<void> _remoteNotificationBackgroundHandler(RemoteMessage message) async {
  logger.i("background handler called");
  logger.i(
      "Handling a background message \n message.data: ${message.data} \n message.messageId: ${message.messageId} \n message.messageType: ${message.messageType} \n message.notification: ${message.notification} \n message.notification.title: ${message.notification?.title}");
}

Future<void> _remoteNotificationForegroundHandler(RemoteMessage message) async {
  logger.i("foreground handler calleed");
  logger.i(
      "Handling a foreground message \n message.data: ${message.data} \n message.messageId: ${message.messageId} \n message.messageType: ${message.messageType} \n message.notification: ${message.notification} \n message.notification.title: ${message.notification?.title}");
}

final sl = GetIt.instance;

Future<void> setupAuthentication() async {
  final authenticationRepository = sl<AuthenticationRepository>();
  await authenticationRepository.user.first;
}

Future<void> setupFirebase() async {
  try {
    await Firebase.initializeApp();
  } catch (e) {
    logger.e(e);
  }
}

void setupTimeZones() {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Berlin'));
}

Future<void> setupDependencies() async {
  // =============== DataSource ===============
  // SharedPreferences
  var sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(
    () => sharedPreferences,
  );

  sl.registerLazySingleton<AppConfigurationService>(
      () => LocalAppConfigurationService());

  sl.registerLazySingleton<Cache>(() => InMemoryCache());

  sl.registerLazySingleton<AuthService>(
      () => AuthServiceFirebase(firebaseAuth: sl()));

  sl.registerLazySingleton<CommunicationRepository>(
      () => LocalCommunicationRepository());

  // =============== Chat ===============
  // Bloc

  sl.registerFactory(
    () => FriendRequestCubit(
        getFriendList: sl(),
        cancelFriendRequest: sl(),
        getSentFriendRequests: sl(),
        sendFriendRequest: sl()),
  );

  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryFirebase(firestoreService: sl(), authService: sl()),
  );

  sl.registerLazySingleton<GetFriendList>(() => GetFriendList(sl()));
  sl.registerLazySingleton<CancelFriendRequest>(
      () => CancelFriendRequest(sl(), sl()));
  sl.registerLazySingleton<GetSentFriendRequests>(
      () => GetSentFriendRequests(sl()));
  sl.registerLazySingleton<SendFriendRequest>(() => SendFriendRequest(
        sl(),
        sl(),
      ));
  sl.registerLazySingleton<GetChats>(() => GetChats(sl()));
  sl.registerLazySingleton<GetMessages>(() => GetMessages(sl()));
  sl.registerLazySingleton<SendChatRequestResponse>(
      () => SendChatRequestResponse(sl()));
  sl.registerLazySingleton<SendMessage>(() => SendMessage(sl()));
  sl.registerLazySingleton<GetUser>(() => GetUser(sl()));
  sl.registerFactory(() => ChatroomCubit(
        getChats: sl(),
        getMessages: sl(),
        getUser: sl(),
        getAppUser: sl(),
        sendChatRequestResponse: sl(),
        sendMessage: sl(),
      ));

  sl.registerFactory(
    () => ChatRequestsCubit(sl(), sl()),
  );

// Todo: change to singleton
  sl.registerFactory(
    () => GetAllUserChats(
        chatRepository: sl(),
        userRepository: sl(),
        authenticationRepository: sl()),
  );

  /*sl.registerFactory(
    () => ChatLoadedCubit(sendMessage: sl<SendChatMessageUseCase>()),
  );*/
  sl.registerFactory(
    () => ChatListCubit(sl(), sl()),
  );
  /* sl.registerFactory(
    () => ChatRequestListBloc(sl(), sl()),
  );*/
  sl.registerFactory(
    () => ActivityFeedBloc(),
  );
  sl.registerFactory(
    () => ActivityRequestListBloc(),
  );
  sl.registerFactory(
    () => ActivityJoinedListBloc(),
  );

  // UseCase
  sl.registerLazySingleton(() => GetChatRequestsUseCase(sl(), sl(), sl()));
  sl.registerLazySingleton(() => SendChatMessageUseCase(sl()));

  // Repo

  // =============== User ===============

  // UseCase
  sl.registerLazySingleton(() => GetAuthenticatedUser(sl(), sl()));

  // Repo
  sl.registerLazySingleton(
      () => AppUserRepository(cache: sl(), firestoreService: sl()));

  // =============== Repository ===============

  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepository(cache: sl(), authService: sl()),
  );

  // =============== Notification ===============

  // Service
  sl.registerLazySingleton<NotificationService>(
    () => FirebaseNotificationService(),
  );
  sl.registerLazySingleton<DeviceTokenService>(
    () => DeviceTokenService(),
  );

  // UseCase
  sl.registerLazySingleton<StartRemoteNotifications>(() =>
      StartRemoteNotifications(
          notificationService: sl<NotificationService>(),
          deviceTokenService: sl<DeviceTokenService>(),
          backgroundHandler: _remoteNotificationBackgroundHandler,
          foregroundHandler: _remoteNotificationForegroundHandler));

  sl.registerLazySingleton<WeeklyReminderUseCase>(() => WeeklyReminderUseCase(
        appReminderRepository: sl<LocalAppReminderRepository>(),
        notificationService: sl<NotificationService>(),
      ));

  // Repository

  sl.registerLazySingleton<LocalAppReminderRepository>(
    () => LocalAppReminderRepository(
        localConfiguration: sl<AppConfigurationService>()),
  );

  // ============== Discover ====================
  sl.registerLazySingleton<DiscoverRepository>(
    () => FirebaseDiscoverRepository(firestoreService: sl()),
  );

  sl.registerLazySingleton(() => FindPeers(
      userRepository: sl(),
      authenticationRepository: sl(),
      discoverRepository: sl()));
  sl.registerLazySingleton(() => FindUserByName(userRepository: sl()));
  // ============== Activity ====================
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Service

  // Repository

  sl.registerLazySingleton<FirestoreService>(() => FirestoreService(
        firestore: sl<FirebaseFirestore>(),
      ));

  sl.registerLazySingleton<ActivityRepository>(() => FirebaseActivityRepository(
        prefs: sl<SharedPreferences>(),
        firestoreService: sl<FirestoreService>(),
        auth: sl<FirebaseAuth>(),
      ));

  sl.registerLazySingleton<LocationRepository>(() => LocalLocationRepository());

  sl.registerLazySingleton<ActivityReminderRepository>(() =>
      LocalActivityReminderRepository(
          prefs: sl<SharedPreferences>(),
          notificationService: sl<NotificationService>()));

  // UseCase
  sl.registerLazySingleton<ScheduleActivityReminderUseCase>(
      () => ScheduleActivityReminderUseCase(sl()));
  sl.registerLazySingleton<IsIOSWithoutNotificationPermissionUseCase>(
      () => IsIOSWithoutNotificationPermissionUseCase(sl()));
  sl.registerLazySingleton<CalculateUpcomingReminderDatesUseCase>(
      () => CalculateUpcomingReminderDatesUseCase());
  sl.registerLazySingleton<UpdateJoinedActivitiesRemindersUseCase>(() =>
      UpdateJoinedActivitiesRemindersUseCase(
          activityReminderRepository: sl(),
          filterUpcomingRemindersUseCase: sl(),
          isIOSWithoutNotificationPermission: sl(),
          scheduleActivityReminderUseCase: sl()));
  sl.registerLazySingleton<UpdateCreatedActivitiesRemindersUseCase>(() =>
      UpdateCreatedActivitiesRemindersUseCase(
          filterUpcomingRemindersUseCase: sl(),
          activityReminderRepository: sl(),
          isIOSWithoutNotificationPermission: sl(),
          scheduleActivityReminderUseCase: sl()));

  // =============== Friends ===============
  sl.registerLazySingleton<FriendRepository>(() => FirebaseFriendRepository(
        firestoreService: sl<FirestoreService>(),
      ));

  // ============== Analytics ====================
  sl.registerLazySingleton<AnalyticsService>(() => FirebaseAnalyticsService());

  sl.registerLazySingleton<AnalyticsRepository>(
      () => FirebaseAnalyticsRepository(analyticsService: sl()));
}
