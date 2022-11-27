import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/app_tab_view/domain/notification_service.dart';
import 'package:peerpal/app_tab_view/domain/usecase/start_remote_notifications.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:peerpal/home/domain/start_rememberme_notifications.dart';
import 'package:peerpal/notification/presentation/notification_page_content.dart';
import 'package:peerpal/setup.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final AppUserRepository _appuserRepository;
  final GetAuthenticatedUser _getAuthenticatedUser;
  final StartRemoteNotifications _startRemoteNotifications;
  final StartRememberMeNotifications _startRememberMeNotifications;

  HomeCubit(this._appuserRepository, this._getAuthenticatedUser,
      this._startRemoteNotifications, this._startRememberMeNotifications)
      : super(HomeInitial());

  Future<void> getCurrentUserInformation() async {
    emit(HomeLoading());
    final home = await _getAuthenticatedUser();
    emit(HomeLoaded(home));
    loadCurrentSetupFlowState();
  }

  Future<void> loadCurrentSetupFlowState() async {
    PeerPALUser userInformation = await _getAuthenticatedUser();
    if (userInformation.isProfileNotComplete) {
      emit(ProfileSetupState(userInformation));
    } else if (userInformation.isDiscoverNotComplete) {
      emit(DiscoverSetupState(userInformation));
    } else if (!(await _hasPermission()) &&
        Platform.isIOS &&
        !(await sl<NotificationService>().hasAskedForPermission()) &&
        !notificationRequestButtonClicked) {
      print("Is ios: " + Platform.isIOS.toString());
      // ToDo: await _hasPermission() or permissionAlreadyAsked (global?)

      emit(NotificationSetupState(userInformation));
    } else {
      _startRemoteNotifications();
      _startRememberMeNotifications();
      emit(SetupCompletedState(0));
    }
  }

  Future<bool> _hasPermission() async {
    NotificationService notificationService = sl<NotificationService>();
    bool hasPermission = (await notificationService.hasPermission());
    return hasPermission;
  }

  void indexChanged(int index) {
    emit(SetupCompletedState(index));
  }
}
