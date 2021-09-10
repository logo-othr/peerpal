import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/bloc_observer.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/memory_cache.dart';

import 'app/app.dart';

Future<void> main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final authenticationRepository = AppUserRepository(cache: MemoryCache());
  await authenticationRepository.user.first;
  runApp(App(authenticationRepository: authenticationRepository));
}

class App extends StatelessWidget {
  const App({
    Key? key,
    required AppUserRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(key: key);

  final AppUserRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        create: (_) => AppBloc(
          appUserRepository: _authenticationRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}


