import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/account_setup/domain/weekly_reminder_usecase.dart';
import 'package:peerpal/activity/domain/usecase/has_ios_notification_permission_usecase.dart';
import 'package:peerpal/app/data/app_configuration_service.dart';
import 'package:peerpal/app/domain/notification/usecase/start_remote_notifications.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:peerpal/setup.dart';

part 'setup_state.dart';

class SetupCubit extends Cubit<SetupState> {
  final GetAuthenticatedUser _getAuthenticatedUser;
  final StartRemoteNotifications _startRemoteNotifications;
  final WeeklyReminderUseCase _startRememberMeNotifications;
  final IsIOSWithoutNotificationPermissionUseCase
      _isIOSWithoutNotificationPermission;

  SetupCubit(
      this._getAuthenticatedUser,
      this._startRemoteNotifications,
      this._startRememberMeNotifications,
      this._isIOSWithoutNotificationPermission)
      : super(HomeInitial());

  Future<void> getCurrentUserInformation() async {
    emit(HomeLoading());
    final home = await _getAuthenticatedUser();
    emit(HomeLoaded(home));
    loadCurrentSetupFlowState();
  }

  Future<void> loadCurrentSetupFlowState() async {
    PeerPALUser userInformation = await _getAuthenticatedUser();

    // if the profile is not complete, start the profile setup
    if (userInformation.isProfileNotComplete) {
      emit(ProfileSetupState(userInformation));
    }
    // if the discover setup is not complete, start the discover setup
    else if (userInformation.isDiscoverNotComplete) {
      emit(DiscoverSetupState(userInformation));
    }
    // if the platform is ios and the notification permission
    // was never requested, start the notification setup
    else if (await _isPermissionNotRequestedOnIOS()) {
      emit(NotificationSetupState(userInformation));
    } else {
      // Setup is complete
      // Start the notification handler,
      // unless the platform is iOS and no authorization has been granted.
      if (!await _isIOSWithoutNotificationPermission()) {
        _startRemoteNotifications();
        _startRememberMeNotifications('Wöchentliche Erinnerung - PeerPAL',
            'Hi, wir würden uns freuen, wenn du PeerPAL diese Woche nutzt!');
      }
      emit(SetupCompletedState(0));
    }
  }

  Future<bool> _isPermissionNotRequestedOnIOS() async {
    bool isIOSWithoutPermission = await _isIOSWithoutNotificationPermission();
    bool hasAskedForPermission =
        (await sl<AppConfigurationService>().hasAskedForPermission());

    return (isIOSWithoutPermission && !hasAskedForPermission);
  }

  void indexChanged(int index) {
    emit(SetupCompletedState(index));
  }
}
