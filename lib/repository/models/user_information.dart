
import 'package:equatable/equatable.dart';

class UserInformation extends Equatable {
  const UserInformation(
      {
        this.name,
        this.age,
        this.phoneNumber,
        this.imagePath});

  final String? name;
  final int? age;
  final String? phoneNumber;
  final String? imagePath;

  static const empty = UserInformation();

  bool get isEmpty => this == UserInformation.empty;

  bool get isNotEmpty => this != UserInformation.empty;

  @override
  List<Object?> get props => [name, age, phoneNumber, imagePath];

  UserInformation copyWith({
    String? name,
    int? age,
    String? phoneNumber,
    String? imagePath,
  }) {
    return UserInformation(
      age: age ?? this.age,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}