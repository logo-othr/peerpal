import 'package:equatable/equatable.dart';

class Location extends Equatable {
  const Location( {
    required this.place,
    this.zipcode,
    this.street,
    this.streetNumber,
  });

  final String place;
  final String? zipcode;
  final String? street;
  final String? streetNumber;

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      place: json['place'] as String,
      zipcode: json['zipcode'] as String,
    );
  }

  @override
  List<Object?> get props => [place];

}