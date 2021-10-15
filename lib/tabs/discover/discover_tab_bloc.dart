import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'discover_tab_event.dart';
part 'discover_tab_state.dart';

class DiscoverTabBloc extends Bloc<DiscoverTabEvent, DiscoverTabState> {
  DiscoverTabBloc() : super(DiscoverTabInitial());

  @override
  Stream<DiscoverTabState> mapEventToState(
    DiscoverTabEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
