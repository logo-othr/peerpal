import 'package:json_annotation/json_annotation.dart';

enum VideoIdentifier {
  @JsonValue("discover_tab")
  discover_tab,
  @JsonValue("activity_tab")
  activity_tab,
  @JsonValue("chat_tab")
  chat_tab,
  @JsonValue("settings_tab")
  settings_tab,
  @JsonValue("friends_tab")
  friends_tab,
  @JsonValue("chat_request_tab")
  chat_request_tab,
  @JsonValue("activity_invitation_tab")
  activity_invitation_tab,
  @JsonValue("settings_profile_tab")
  settings_profile_tab
}
