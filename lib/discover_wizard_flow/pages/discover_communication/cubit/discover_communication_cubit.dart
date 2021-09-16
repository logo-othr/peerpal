import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'discover_communication_state.dart';

class DiscoverCommunicationCubit extends Cubit<DiscoverCommunicationState> {
  DiscoverCommunicationCubit() : super(DiscoverCommunicationInitial());
}
