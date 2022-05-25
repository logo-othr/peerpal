part of 'discover_age_cubit.dart';

@immutable
abstract class DiscoverAgeState extends Equatable {
  final List<int> ages = (List<int>.generate(10, (i) => i + 10));

  final int selctedFromAge;
  final int selectedToAge;
  final int fromMinAge = 0;
  final int fromMaxAge = 120;
  final int toMinAge = 0;
  final int toMaxAge = 120;

  DiscoverAgeState(this.selctedFromAge, this.selectedToAge);
}

class DiscoverAgeInitial extends DiscoverAgeState {
  DiscoverAgeInitial(int selectedFromAge, int selectedToAge)
      : super(selectedFromAge, selectedToAge);

  @override
  List<Object?> get props => [selctedFromAge, selectedToAge, fromMinAge, fromMaxAge, toMinAge, toMaxAge];
}

class DiscoverAgePosting extends DiscoverAgeState {
  DiscoverAgePosting(int selectedFromAge, int selectedToAge)
      : super(selectedFromAge, selectedToAge);

  @override
  List<Object?> get props => [selctedFromAge, selectedToAge];
}

class DiscoverAgePosted extends DiscoverAgeState {
  DiscoverAgePosted(int selectedFromAge, int selectedToAge)
      : super(selectedFromAge, selectedToAge);

  @override
  List<Object?> get props => [selctedFromAge];
}

class DiscoverAgeError extends DiscoverAgeState {
  final String message;

  DiscoverAgeError(this.message, int selectedFromAge, int selectedToAge)
      : super(selectedFromAge, selectedToAge);

  @override
  List<Object?> get props => [message, selctedFromAge, selectedToAge];
}
