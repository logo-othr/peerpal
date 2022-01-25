import 'package:get_it/get_it.dart';
import 'package:peerpal/chat/data/repository/chat_repository_firebase.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/domain/usecases/get_chat_requests_for_user.dart';
import 'package:peerpal/chat/domain/usecases/get_chats_for_users.dart';
import 'package:peerpal/chat/domain/usecases/get_userchat_for_chat.dart';
import 'package:peerpal/chat/presentation/chat_list/bloc/chat_list_bloc.dart';
import 'package:peerpal/chat/presentation/chat_request_list/bloc/chat_request_list_bloc.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/cache.dart';
import 'package:peerpal/repository/memory_cache.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // =============== Chat ===============
  // Bloc
  sl.registerFactory(
    () => ChatListBloc(sl(), sl(), sl()),
  );
  sl.registerFactory(
    () => ChatRequestListBloc(sl(), sl()),
  );
  // UseCase
  sl.registerLazySingleton(() => GetChatsForUser(sl(), sl()));
  sl.registerLazySingleton(() => GetUserChatForChat(sl(), sl()));
  sl.registerLazySingleton(() => GetChatRequestForUser(sl(), sl()));

  // Repo
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryFirebase(),
  );
  sl.registerLazySingleton(() => AppUserRepository(cache: sl()));

  // Source/Service/Cache
  sl.registerLazySingleton<Cache>(() => MemoryCache());
}
