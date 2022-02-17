import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:peerpal/repository/models/location.dart';

part 'activity.g.dart';

@JsonSerializable(explicitToJson: true)
class Activity extends Equatable {

  static const empty = Activity();

  bool get isEmpty => this == Activity.empty;

  bool get isNotEmpty => this != Activity.empty;

  final String? id;
  final String? name;
  final String? code;
  final String? description;
  final String? creatorId;
  final String? creatorName;
  final DateTime? date;
  final Location? location;
  final List<String>? attendeeIds;
  final List<String>? invitationIds;
  final bool? public;


  const Activity({
    this.id,
    this.name,
    this.code,
    this.description,
    this.creatorId,
    this.creatorName,
    this.date,
    this.location,
    this.attendeeIds,
    this.invitationIds,
    this.public,
  });

  @override
  String toString() {
    return 'Activity{' +
        ' id: $id,' +
        ' name: $name,' +
        ' code: $code,' +
        ' description: $description,' +
        ' creatorId: $creatorId,' +
        ' creatorName: $creatorName,' +
        ' date: $date,' +
        ' location: $location,' +
        ' attendeeIds: $attendeeIds,' +
        ' invitationIds: $invitationIds,' +
        ' public: $public,' +
        '}';
  }

  Activity copyWith({
    String? id,
    String? name,
    String? code,
    String? description,
    String? creatorId,
    String? creatorName,
    DateTime? date,
    Location? location,
    List<String>? attendeeIds,
    List<String>? invitationIds,
    bool? public,
  }) {
    return Activity(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      date: date ?? this.date,
      location: location ?? this.location,
      attendeeIds: attendeeIds ?? this.attendeeIds,
      invitationIds: invitationIds ?? this.invitationIds,
      public: public ?? this.public,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'code': this.code,
      'description': this.description,
      'creatorId': this.creatorId,
      'creatorName': this.creatorName,
      'date': this.date,
      'location': this.location,
      'attendeeIds': this.attendeeIds,
      'invitationIds': this.invitationIds,
      'public': this.public,
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        description,
        creatorId,
        creatorName,
        date,
        location,
        attendeeIds,
        invitationIds,
        public
      ];
}
