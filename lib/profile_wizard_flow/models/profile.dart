class Profile {
  const Profile({this.age});

  final int? age;

  Profile copyWith({
    int? age,
  }) {
    return Profile(
      age: age ?? this.age,
    );
  }
}
