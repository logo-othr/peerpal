import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/bloc_observer.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/chat_repository.dart';
import 'package:peerpal/repository/memory_cache.dart';

import 'app/app.dart';

Future<void> main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final authenticationRepository = AppUserRepository(cache: MemoryCache());
  final chatRepository = ChatRepository();
  await authenticationRepository.user.first;
  //await DebugHelper.createExampleUsers(appUserRepository: authenticationRepository, emailBase:  'pptestmailbase224', password: 'Abc12345678*');
  runApp(App(
      authenticationRepository: authenticationRepository,
      chatRepository: chatRepository));
}

class App extends StatelessWidget {
  const App({
    Key? key,
    required AppUserRepository authenticationRepository,
    required ChatRepository chatRepository,
  })  : _authenticationRepository = authenticationRepository,
        _chatRepository = chatRepository,
        super(key: key);

  final AppUserRepository _authenticationRepository;
  final ChatRepository _chatRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: _authenticationRepository,
        ),
        RepositoryProvider.value(
          value: _chatRepository,
        )
      ],
      child: BlocProvider(
        create: (_) => AppBloc(
          appUserRepository: _authenticationRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}
