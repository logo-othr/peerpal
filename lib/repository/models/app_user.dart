import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  const AppUser({
    required this.id,
    this.email,
  });

  final String id;
  final String? email;

  static const empty = AppUser(id: '');

  bool get isEmpty => this == AppUser.empty;

  bool get isNotEmpty => this != AppUser.empty;

  @override
  List<Object?> get props => [email, id];

  AppUser copyWith({
    String? email,
    String? id,
  }) {
    return AppUser(
      email: email ?? this.email,
      id: id ?? this.id,
    );
  }
}
