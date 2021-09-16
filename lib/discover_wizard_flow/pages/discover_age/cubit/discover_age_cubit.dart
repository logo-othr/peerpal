import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'discover_age_state.dart';

class DiscoverAgeCubit extends Cubit<DiscoverAgeState> {
  DiscoverAgeCubit() : super(DiscoverAgeInitial());
}
