import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'discover_location_state.dart';

class DiscoverLocationCubit extends Cubit<DiscoverLocationState> {
  DiscoverLocationCubit() : super(DiscoverLocationInitial());
}
