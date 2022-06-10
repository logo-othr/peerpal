import 'package:get_it/get_it.dart';
import 'package:peerpal/activities/activity_feed/bloc/activity_feed_bloc.dart';
import 'package:peerpal/activities/activity_joined_list/bloc/activity_joined_list_bloc.dart';
import 'package:peerpal/activities/activity_request_list/bloc/activity_request_list_bloc.dart';
import 'package:peerpal/chat/data/repository/chat_repository_firebase.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/domain/usecases/get_chat_requests_for_user.dart';
import 'package:peerpal/chat/domain/usecases/get_chats_for_users.dart';
import 'package:peerpal/chat/domain/usecases/get_userchat_for_chat.dart';
import 'package:peerpal/chat/presentation/chat_list/bloc/chat_list_bloc.dart';
import 'package:peerpal/chat/presentation/chat_request_list/bloc/chat_request_list_bloc.dart';
import 'package:peerpal/repository/activity_repository.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/authentication_repository.dart';
import 'package:peerpal/repository/cache.dart';
import 'package:peerpal/repository/get_user_usecase.dart';
import 'package:peerpal/repository/memory_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {

  // =============== DataSource ===============
  // SharedPreferences
  var sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(
        () => sharedPreferences,
  );

  sl.registerLazySingleton<Cache>(() => MemoryCache());


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


  sl.registerLazySingleton<ActivityRepository>(
        () => ActivityRepository(sharedPreferences),
  );



  sl.registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepository(cache: sl()),
  );



}
