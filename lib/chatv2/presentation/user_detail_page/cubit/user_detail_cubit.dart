import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/discover_feed_v2/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed_v2/domain/peerpal_user.dart';

part 'user_detail_state.dart';

class UserDetailCubit extends Cubit<UserDetailState> {
  final AppUserRepository appUserRepository;

  UserDetailCubit({required this.appUserRepository})
      : super(UserDetailInitial());

  void loadUser(String userId) async {
    PeerPALUser user = await appUserRepository.getUser(userId);
    emit(UserDetailLoaded(user: user));
  }
}
