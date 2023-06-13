import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:peerpal/account_setup/data/rememberme_notification_repository.dart';
import 'package:peerpal/account_setup/domain/start_rememberme_notifications.dart';
import 'package:peerpal/activity/data/repository/firebase_activity_repository.dart';
import 'package:peerpal/activity/data/repository/local_activity_reminder_repository.dart';
import 'package:peerpal/activity/domain/repository/activity_reminder_repository.dart';
import 'package:peerpal/activity/domain/repository/activity_repository.dart';
import 'package:peerpal/activity/domain/usecase/calculate_upcoming_reminder_dates_usecase.dart';
import 'package:peerpal/activity/domain/usecase/has_ios_notification_permission_usecase.dart';
import 'package:peerpal/activity/domain/usecase/update_created_activities_reminders_usecase.dart';
import 'package:peerpal/activity/domain/usecase/update_joined_activities_reminders_usecase.dart';
import 'package:peerpal/activity/presentation/activity_feed/bloc/activity_feed_bloc.dart';
import 'package:peerpal/activity/presentation/activity_requests/bloc/activity_request_list_bloc.dart';
import 'package:peerpal/activity/presentation/joined_activities/bloc/activity_joined_list_bloc.dart';
import 'package:peerpal/app/data/analytics/datasources/firebase_analytics_service.dart';
import 'package:peerpal/app/data/analytics/repository/firebase_analytics_repository.dart';
import 'package:peerpal/app/data/core/memory_cache.dart';
import 'package:peerpal/app/data/location/repository/local_location_repository.dart';
import 'package:peerpal/app/data/notification/firebase_notification_service.dart';
import 'package:peerpal/app/domain/analytics/analytics_repository.dart';
import 'package:peerpal/app/domain/analytics/analytics_service.dart';
import 'package:peerpal/app/domain/core/cache.dart';
import 'package:peerpal/app/domain/location/location_repository.dart';
import 'package:peerpal/app/domain/notification/notification_service.dart';
import 'package:peerpal/app/domain/notification/usecase/start_remote_notifications.dart';
import 'package:peerpal/app_logger.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/data/repository/chat_repository_firebase.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/domain/usecases/get_chat_requests_for_user.dart';
import 'package:peerpal/chat/domain/usecases/get_chats_for_users.dart';
import 'package:peerpal/chat/domain/usecases/get_userchat_for_chat.dart';
import 'package:peerpal/chat/presentation/chat_list/bloc/chat_list_bloc.dart';
import 'package:peerpal/chat/presentation/chat_request_list/bloc/chat_request_list_bloc.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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

  sl.registerLazySingleton<Cache>(() => InMemoryCache());

  // =============== Chat ===============
  // Bloc
  sl.registerFactory(
    () => ChatListBloc(sl(), sl(), sl()),
  );
  sl.registerFactory(
    () => ChatRequestListBloc(sl(), sl()),
  );
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
  sl.registerLazySingleton(() => GetChatsForUser(sl(), sl()));
  sl.registerLazySingleton(() => GetUserChatForChat(sl(), sl(), sl()));
  sl.registerLazySingleton(() => GetChatRequestForUser(sl(), sl(), sl()));

  // Repo
  sl.registerLazySingleton<ChatRepository>(
        () => ChatRepositoryFirebase(),
  );

  // =============== User ===============

  // UseCase
  sl.registerLazySingleton(() => GetAuthenticatedUser(sl(), sl()));

  // Repo
  sl.registerLazySingleton(() => AppUserRepository(cache: sl()));

  // =============== Repository ===============

  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepository(cache: sl()),
  );

  // =============== Notification ===============

  // Service
  sl.registerLazySingleton<NotificationService>(
    () => FirebaseNotificationService(),
  );

  // UseCase
  sl.registerLazySingleton<StartRemoteNotifications>(() =>
      StartRemoteNotifications(
          notificationService: sl<NotificationService>(),
          remoteNotificationBackgroundHandler:
              _remoteNotificationBackgroundHandler,
          remoteNotificationForegroundHandler:
              _remoteNotificationForegroundHandler));

  sl.registerLazySingleton<StartRememberMeNotifications>(
      () => StartRememberMeNotifications(
            rememberMeNotificationRepository:
                sl<RememberMeNotificationRepository>(),
          ));

  // Repository

  sl.registerLazySingleton<RememberMeNotificationRepository>(
    () => RememberMeNotificationRepository(
        notificationService: sl<NotificationService>()),
  );

  // ============== Activity ====================

  // Service
  // UseCase
  sl.registerLazySingleton<IsIOSWithoutNotificationPermissionUseCase>(
      () => IsIOSWithoutNotificationPermissionUseCase(sl()));
  sl.registerLazySingleton<CalculateUpcomingReminderDatesUseCase>(
      () => CalculateUpcomingReminderDatesUseCase());
  sl.registerLazySingleton<UpdateJoinedActivitiesRemindersUseCase>(() =>
      UpdateJoinedActivitiesRemindersUseCase(
          activityReminderRepository: sl(),
          filterUpcomingRemindersUseCase: sl()));
  sl.registerLazySingleton<UpdateCreatedActivitiesRemindersUseCase>(() =>
      UpdateCreatedActivitiesRemindersUseCase(
          filterUpcomingRemindersUseCase: sl(),
          activityReminderRepository: sl(),
          isIOSWithoutNotificationPermission: sl()));

  // Repository

  sl.registerLazySingleton<ActivityRepository>(
      () => FirebaseActivityRepository(sl()));

  sl.registerLazySingleton<LocationRepository>(() => LocalLocationRepository());

  sl.registerLazySingleton<ActivityReminderRepository>(() =>
      LocalActivityReminderRepository(
          prefs: sl<SharedPreferences>(),
          notificationService: sl<NotificationService>()));

  // ============== Analytics ====================
  sl.registerLazySingleton<AnalyticsService>(() => FirebaseAnalyticsService());

  sl.registerLazySingleton<AnalyticsRepository>(
      () => FirebaseAnalyticsRepository(analyticsService: sl()));
}
