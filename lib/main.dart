import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/bloc_observer.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/injection.dart';
import 'package:peerpal/repository/activity_repository.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';

Future<void> main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await init();
  final authenticationRepository = sl<AppUserRepository>();
  await authenticationRepository.user.first;

  //await DebugHelper.createExampleUsers(appUserRepository: authenticationRepository, emailBase:  'pptestmailbase234', password: 'Abc12345678*');
  runApp(App());
}

class App extends StatelessWidget {
  const App({
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
