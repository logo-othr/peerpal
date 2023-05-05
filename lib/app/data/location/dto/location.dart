import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part '../repository/location.g.dart';

@JsonSerializable()
class Location extends Equatable {
  const Location({
    required this.place,
    this.zipcode,
    this.street,
    this.streetNumber,
  });

  final String place;
  final String? zipcode;
  final String? street;
  final String? streetNumber;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);

  @override
  List<Object?> get props => [place, street, streetNumber];

  Location copyWith({
    final String? place,
    final String? zipcode,
    final String? street,
    final String? streetNumber,
  }) {
    return Location(
      place: place ?? this.place,
      zipcode: zipcode ?? this.zipcode,
      street: street ?? this.street,
      streetNumber: streetNumber ?? this.streetNumber,
    );
  }
}
