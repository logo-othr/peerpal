import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  const AppUser(
      {required this.id,
      this.email,
      this.name,
      this.age,
      this.phoneNumber,
      this.imagePath});

  final String id;
  final String? email;
  final String? name;
  final int? age;
  final String? phoneNumber;
  final String? imagePath;

  static const empty = AppUser(id: '');

  bool get isEmpty => this == AppUser.empty;

  bool get isNotEmpty => this != AppUser.empty;

  @override
  List<Object?> get props => [email, id, name, age, phoneNumber, imagePath];

  AppUser copyWith({
    String? email,
    String? id,
    String? name,
    int? age,
    String? phoneNumber,
    String? imagePath,
  }) {
    return AppUser(
      email: email ?? this.email,
      id: id ?? this.id,
      age: age ?? this.age,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
