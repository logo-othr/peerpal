import 'package:equatable/equatable.dart';

class Location extends Equatable {
  const Location({
    required this.place,
    required this.zipcode,
  });

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      place: map['place'] as String,
      zipcode: map['zipcode'] as String,
    );
  }

  final String place;
  final String zipcode;

  @override
  String toString() {
    return 'Location{${' place: $place,'}${' zipcode: $zipcode,'}}';
  }

  Location copyWith({
    String? place,
    String? zipcode,
  }) {
    return Location(
      place: place ?? this.place,
      zipcode: zipcode ?? this.zipcode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'place': place,
      'zipcode': zipcode,
    };
  }

  @override
  List<Object?> get props => [place, zipcode];
}
