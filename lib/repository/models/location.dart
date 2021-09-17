import 'package:equatable/equatable.dart';

class Location extends Equatable {
  const Location( {
    required this.place,
    required this.zipcode,
    this.street,
    this.streetNumber,
  });

  final String place;
  final String zipcode;
  final String? street;
  final String? streetNumber;

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();


}
