part of 'age_input_cubit.dart';

@immutable
abstract class AgeInputState extends Equatable {
  final List<int> ages = (List<int>.generate(107, (i) => i + 14));

  final int selectedAge;

  AgeInputState(this.selectedAge);
}

class AgeInputInitial extends AgeInputState {
  AgeInputInitial(int selectedAge) : super(selectedAge);

  @override
  List<Object?> get props => [selectedAge];
}

class AgeInputLoaded extends AgeInputState {
  AgeInputLoaded(int selectedAge) : super(selectedAge);

  @override
  List<Object?> get props => [selectedAge];
}

class AgeInputPosting extends AgeInputState {
  AgeInputPosting(int selectedAge) : super(selectedAge);

  @override
  List<Object?> get props => [selectedAge];
}

class AgeInputPosted extends AgeInputState {
  AgeInputPosted(int selectedAge) : super(selectedAge);

  @override
  List<Object?> get props => [selectedAge];
}

class AgeInputError extends AgeInputState {
  final String message;

  AgeInputError(this.message, int selectedAge) : super(selectedAge);

  @override
  List<Object?> get props => [selectedAge];
}
