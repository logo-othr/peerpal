import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:peerpal/app/data/location/dto/location.dart';

part 'activity.g.dart';

@JsonSerializable(explicitToJson: true)
class Activity extends Equatable {
  static const empty = Activity();

  bool get isEmpty => this == Activity.empty;

  bool get isNotEmpty => this != Activity.empty;

  final String? id;

  ///The timestamp is used to store the time when the activity was created.
  final String? timestamp;
  final String? name;
  final int? date;
  final String? code;
  final String? description;
  final String? creatorId;
  final String? creatorName;

  final Location? location;
  final List<String>? attendeeIds;
  final List<String>? invitationIds;
  final bool? public;

  ///The boolean "isAlreadyEvaluatedFromServer" is used to signal the server that it still needs to evaluate the activity.
  ///This boolean should always be false when the activity is created.
  ///Otherwise, the server will not send Push-Notifications to the invited users.
  final bool? isAlreadyEvaluatedFromServer;

  const Activity({
    this.id,
    this.timestamp,
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
    this.isAlreadyEvaluatedFromServer = false,
  });

  @override
  String toString() {
    return 'Activity{' +
        ' id: $id,' +
        ' timestamp: $timestamp,' +
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
        ' isAlreadyEvaluatedFromServer: $isAlreadyEvaluatedFromServer,'
            '}';
  }

  Activity copyWith({
    String? id,
    String? timestamp,
    String? name,
    String? code,
    String? description,
    String? creatorId,
    String? creatorName,
    int? date,
    Location? location,
    List<String>? attendeeIds,
    List<String>? invitationIds,
    bool? public,
    bool? isAlreadyEvaluatedFromServer,
  }) {
    return Activity(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
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
      isAlreadyEvaluatedFromServer:
          isAlreadyEvaluatedFromServer ?? this.isAlreadyEvaluatedFromServer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'timestamp': this.timestamp,
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
      'isAlreadyEvaluatedFromServer': this.isAlreadyEvaluatedFromServer,
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityToJson(this);

  @override
  List<Object?> get props => [
        id,
        timestamp,
        name,
        code,
        description,
        creatorId,
        creatorName,
        date,
        location,
        attendeeIds,
        invitationIds,
        public,
        isAlreadyEvaluatedFromServer,
      ];
}
