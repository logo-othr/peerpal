part of 'discover_communication_cubit.dart';

abstract class DiscoverCommunicationState extends Equatable {
  List<CommunicationType> communicationTypes;
  List<CommunicationType> selectedCommunicationTypes;

  DiscoverCommunicationState(this.communicationTypes, this.selectedCommunicationTypes);
}

class DiscoverCommunicationInitial extends DiscoverCommunicationState {
  DiscoverCommunicationInitial()
      : super([], []);

  @override
  List<Object?> get props => [communicationTypes, selectedCommunicationTypes];
}

class DiscoverCommunicationLoaded extends DiscoverCommunicationState {
  DiscoverCommunicationLoaded(communicationTypes)
      : super(communicationTypes, []);

  @override
  List<Object?> get props => [communicationTypes, selectedCommunicationTypes];
}

class DiscoverCommunicationSelected extends DiscoverCommunicationState {
  DiscoverCommunicationSelected(communications, selectedCommunicationTypes)
      : super(communications, selectedCommunicationTypes);

  @override
  List<Object?> get props => [communicationTypes, selectedCommunicationTypes];
}

class DiscoverCommunicationPosting extends DiscoverCommunicationState {
  DiscoverCommunicationPosting(communications, selectedCommunicationTypes)
      : super(communications, selectedCommunicationTypes);

  @override
  List<Object?> get props => [communicationTypes, selectedCommunicationTypes];
}

class DiscoverCommunicationPosted extends DiscoverCommunicationState {
  DiscoverCommunicationPosted(communications, selectedCommunicationTypes)
      : super(communications, selectedCommunicationTypes);

  @override
  List<Object?> get props => [communicationTypes, selectedCommunicationTypes];
}


class DiscoverCommunicationError extends DiscoverCommunicationState {
  final String message;

  DiscoverCommunicationError(this.message)
      : super([], []);

  @override
  List<Object?> get props => [message];
}
