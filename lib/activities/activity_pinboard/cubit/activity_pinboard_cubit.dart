import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/repository/activity_repository.dart';

part 'activity_pinboard_state.dart';

class PinboardInputCubit extends Cubit<PinboardInputState> {
  PinboardInputCubit(this._activityRepository) : super(const PinboardInputState());

  final ActivityRepository _activityRepository;
}