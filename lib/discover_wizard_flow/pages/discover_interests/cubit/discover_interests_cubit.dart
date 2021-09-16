import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'discover_interests_state.dart';

class DiscoverInterestsCubit extends Cubit<DiscoverInterestsState> {
  DiscoverInterestsCubit() : super(DiscoverInterestsInitial());
}
