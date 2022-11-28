import 'package:json_annotation/json_annotation.dart';

enum VideoIdentifier {
  @JsonValue("discover")
  discover,
  @JsonValue("activity")
  activity,
  @JsonValue("chat")
  chat,
  @JsonValue("settings")
  settings,
  @JsonValue("friends")
  friends,
  @JsonValue("chat_request")
  chat_request,
  @JsonValue("activity_invitation")
  activity_invitation,
  @JsonValue("settings_profile")
  settings_profile,
}
