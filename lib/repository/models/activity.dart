import 'package:peerpal/repository/models/location.dart';

class Activity {
  final String? id;
  final String? name;
  final String? code;
  final String? description;
  final String? creatorId;
  final String? creatorName;
  final DateTime? date;
  final Location? location;
  final List<int>? attendeeIds;
  final List<int>? invitationIds;
  final bool? public;

//<editor-fold desc="Data Methods">

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
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Activity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          code == other.code &&
          description == other.description &&
          creatorId == other.creatorId &&
          creatorName == other.creatorName &&
          date == other.date &&
          location == other.location &&
          attendeeIds == other.attendeeIds &&
          invitationIds == other.invitationIds &&
          public == other.public);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      code.hashCode ^
      description.hashCode ^
      creatorId.hashCode ^
      creatorName.hashCode ^
      date.hashCode ^
      location.hashCode ^
      attendeeIds.hashCode ^
      invitationIds.hashCode ^
      public.hashCode;

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
    List<int>? attendeeIds,
    List<int>? invitationIds,
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

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      description: map['description'] as String,
      creatorId: map['creatorId'] as String,
      creatorName: map['creatorName'] as String,
      date: map['date'] as DateTime,
      location: map['location'] as Location,
      attendeeIds: map['attendeeIds'] as List<int>,
      invitationIds: map['invitationIds'] as List<int>,
      public: map['public'] as bool,
    );
  }

//</editor-fold>
}