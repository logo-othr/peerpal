part of 'age_selection_cubit.dart';

@immutable
abstract class AgeSelectionState {
  final List<int> ages = (List<int>.generate(10, (i) => i + 10));

  final int selectedAge;

  AgeSelectionState(this.selectedAge);
}

class AgeSelectionInitial extends AgeSelectionState {
  AgeSelectionInitial(int selectedAge) : super(selectedAge);
}

class AgeSelectionPosting extends AgeSelectionState {
  AgeSelectionPosting(int selectedAge) : super(selectedAge);
}

class AgeSelectionPosted extends AgeSelectionState {
  AgeSelectionPosted(int selectedAge) : super(selectedAge);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AgeSelectionPosted && o.selectedAge == selectedAge;
  }

  @override
  int get hashCode => selectedAge.hashCode;
}

class AgeSelectionError extends AgeSelectionState {
  final String message;

  AgeSelectionError(this.message, int selectedAge) : super(selectedAge);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AgeSelectionError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
