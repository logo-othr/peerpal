import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    this.email,
  });

  final String id;
  final String? email;

  static const empty = AuthUser(id: '');

  bool get isEmpty => this == AuthUser.empty;

  bool get isNotEmpty => this != AuthUser.empty;

  @override
  List<Object?> get props => [email, id];

  AuthUser copyWith({
    String? email,
    String? id,
  }) {
    return AuthUser(
      email: email ?? this.email,
      id: id ?? this.id,
    );
  }
}
