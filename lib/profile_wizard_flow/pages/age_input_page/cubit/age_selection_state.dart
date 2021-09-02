part of 'age_selection_cubit.dart';

@immutable
abstract class AgeSelectionState extends Equatable {
  final List<int> ages = (List<int>.generate(10, (i) => i + 10));

  final int selectedAge;

  AgeSelectionState(this.selectedAge);
}

class AgeSelectionInitial extends AgeSelectionState {
  AgeSelectionInitial(int selectedAge) : super(selectedAge);

  @override
  List<Object?> get props => [selectedAge];
}

class AgeSelectionPosting extends AgeSelectionState {
  AgeSelectionPosting(int selectedAge) : super(selectedAge);

  @override
  List<Object?> get props => [selectedAge];
}

class AgeSelectionPosted extends AgeSelectionState {
  AgeSelectionPosted(int selectedAge) : super(selectedAge);

  @override
  List<Object?> get props => [selectedAge];
}

class AgeSelectionError extends AgeSelectionState {
  final String message;

  AgeSelectionError(this.message, int selectedAge) : super(selectedAge);

  @override
  List<Object?> get props => [selectedAge];
}
