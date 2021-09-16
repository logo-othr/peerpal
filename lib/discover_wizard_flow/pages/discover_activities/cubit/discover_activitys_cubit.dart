import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'discover_activitys_state.dart';

class DiscoverActivitysCubit extends Cubit<DiscoverActivitysState> {
  DiscoverActivitysCubit() : super(DiscoverActivitysInitial());
}
