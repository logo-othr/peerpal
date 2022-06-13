part of 'discover_communication_cubit.dart';

abstract class DiscoverCommunicationState extends Equatable {
  List<CommunicationType> communicationTypes;
  List<CommunicationType> selectedCommunicationTypes;

  DiscoverCommunicationState(
      this.communicationTypes, this.selectedCommunicationTypes);
}

class DiscoverCommunicationInitial extends DiscoverCommunicationState {
  DiscoverCommunicationInitial() : super([], []);

  @override
  List<Object?> get props => [communicationTypes, selectedCommunicationTypes];
}

class DiscoverCommunicationLoaded extends DiscoverCommunicationState {
  DiscoverCommunicationLoaded(List<CommunicationType> communicationTypes)
      : super(communicationTypes, []);

  @override
  List<Object?> get props => [communicationTypes, selectedCommunicationTypes];
}

class DiscoverCommunicationSelected extends DiscoverCommunicationState {
  DiscoverCommunicationSelected(List<CommunicationType> communications,
      List<CommunicationType> selectedCommunicationTypes)
      : super(communications, selectedCommunicationTypes);

  @override
  List<Object?> get props => [communicationTypes, selectedCommunicationTypes];
}

class DiscoverCommunicationPosting extends DiscoverCommunicationState {
  DiscoverCommunicationPosting(List<CommunicationType> communications,
      List<CommunicationType> selectedCommunicationTypes)
      : super(communications, selectedCommunicationTypes);

  @override
  List<Object?> get props => [communicationTypes, selectedCommunicationTypes];
}

class DiscoverCommunicationPosted extends DiscoverCommunicationState {
  DiscoverCommunicationPosted(List<CommunicationType> communications,
      List<CommunicationType> selectedCommunicationTypes)
      : super(communications, selectedCommunicationTypes);

  @override
  List<Object?> get props => [communicationTypes, selectedCommunicationTypes];
}

class DiscoverCommunicationError extends DiscoverCommunicationState {
  final String message;

  DiscoverCommunicationError(this.message) : super([], []);

  @override
  List<Object?> get props => [message];
}
