import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/bloc/app_bloc.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/home/cubit/home_cubit.dart';
import 'package:peerpal/home/routes/routes.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/user_information.dart';
import 'package:peerpal/widgets/custom_tab_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(context.read<AppUserRepository>()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
        bloc: BlocProvider.of<HomeCubit>(context)..getCurrentUserInformation(),
        builder: (context, state) {
          return MaterialApp(
              theme: ThemeData(
                  primarySwatch: primaryColor,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  inputDecorationTheme: InputDecorationTheme(
                    contentPadding: const EdgeInsets.fromLTRB(30, 20, 0, 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: primaryColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: primaryColor,
                          width: 3,
                        )),
                  )),
              home: (state is HomeLoaded)
                  ? FlowBuilder<UserInformation>(
                      state: state.userInformation,
                      onGeneratePages: onGenerateHomeViewPages,
                    )
                  : Container(
                      child: Text("Nicht geladen"),
                    ));
        });
  }
}

class MyTabView extends StatelessWidget {
  MyTabView({Key? key}) : super(key: key);

  static MaterialPage<void> page() {
    return MaterialPage<void>(child: MyTabView());
  }

  final tabs = [
    Center(
      child: Container(child: FirstTabPage()),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PeerPAL'),
        actions: <Widget>[
          IconButton(
            key: const Key('homePage_logout_iconButton'),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context.read<AppBloc>().add(AppLogoutRequested()),
          )
        ],
      ),
      bottomNavigationBar: CustomTabBar(),
      body: tabs[0],
    );
  }
}

class FirstTabPage extends StatelessWidget {
  const FirstTabPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
