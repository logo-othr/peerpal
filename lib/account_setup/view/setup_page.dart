import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/account_setup/domain/weekly_reminder_usecase.dart';
import 'package:peerpal/account_setup/view/cubit/setup_cubit.dart';
import 'package:peerpal/activity/domain/usecase/has_ios_notification_permission_usecase.dart';
import 'package:peerpal/app/domain/notification/usecase/start_remote_notifications.dart';
import 'package:peerpal/app/presentation/tabview/view/tabview.dart';
import 'package:peerpal/app_logger.dart';
import 'package:peerpal/discover_setup/discover_wizard_flow.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:peerpal/notification/presentation/notification_page.dart';
import 'package:peerpal/profile_setup/profile_wiazrd_flow.dart';
import 'package:peerpal/setup.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class SetupPage extends StatelessWidget {
  final int initialTabIndex;

  const SetupPage({Key? key, this.initialTabIndex = 0}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: SetupPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SetupCubit(
        sl<GetAuthenticatedUser>(),
        sl<StartRemoteNotifications>(),
        sl<WeeklyReminderUseCase>(),
        sl<IsIOSWithoutNotificationPermissionUseCase>(),
      )..loadCurrentSetupFlowState(),
      child: const SetupPageContent(),
    );
  }
}

class SetupPageContent extends StatefulWidget {
  final int initialTabIndex;

  const SetupPageContent({Key? key, this.initialTabIndex = 0})
      : super(key: key);

  @override
  State<SetupPageContent> createState() => _SetupPageContentState();
}

class _SetupPageContentState extends State<SetupPageContent> {
  // notification example from https://firebase.flutter.dev/docs/messaging/notifications/
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessageFromTerminatedState(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp
        .listen(_handleMessageFromBackgroundStreamState);
  }

  void _handleMessageFromTerminatedState(RemoteMessage message) async {
    context.read<SetupCubit>().indexChanged(3);
    logger.i("got message from terminated state stream");
  }

  void _handleMessageFromBackgroundStreamState(RemoteMessage message) async {
    context.read<SetupCubit>().indexChanged(3);
    logger.i("got message from background stream");
  }

  @override
  void initState() {
    setupInteractedMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SetupCubit, SetupState>(
      listener: (context, state) async {
        if (state is ProfileSetupState) {
          await loadProfileSetup(context, state);
        }
        if (state is DiscoverSetupState) {
          await loadDiscoverSetup(context, state);
        }
        if (state is NotificationSetupState) {
          await loadNotificationSetup();
        }
      },
      child: BlocBuilder<SetupCubit, SetupState>(
          bloc: BlocProvider.of<SetupCubit>(context),
          builder: (context, state) {
            if (state is SetupCompletedState) {
              return AppTabView();
            }
            return _LoadingIndicator();
          }),
    );
  }

  Future<void> loadNotificationSetup() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationPage()),
    );

    await BlocProvider.of<SetupCubit>(context).loadCurrentSetupFlowState();
  }

  Future<void> loadProfileSetup(
      BuildContext context, ProfileSetupState state) async {
    await Navigator.of(context).push(
      ProfileSetupFlow.route(state.userInformation),
    );
    await BlocProvider.of<SetupCubit>(context).loadCurrentSetupFlowState();
  }

  Future<void> loadDiscoverSetup(
      BuildContext context, DiscoverSetupState state) async {
    await Navigator.of(context).push(
      DiscoverSetupFlow.route(state.userInformation),
    );
    BlocProvider.of<SetupCubit>(context).loadCurrentSetupFlowState();
  }

  Widget _LoadingIndicator() {
    return Container(
      child: Container(
        child: Scaffold(
            appBar: CustomAppBar(
              "PeerPAL",
              hasBackButton: false,
            ),
            body: Center(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                    child: Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                          const SizedBox(height: 300),
                          CustomPeerPALHeading1("Laden..."),
                          CircularProgressIndicator(),
                        ]))))),
      ),
    );
  }
}
