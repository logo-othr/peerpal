import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/app/domain/support_videos/support_video.dart';

abstract class AnalyticsService {
  addVideoClick(String userId, String timestamp, SupportVideo supportVideo);

  addUserSearch(String userId, String timestamp, String searchQuery);

  addPublicActivityClick(String userId, String timestamp, Activity activity);

  addAddActivityClick(String userId, String timestamp, String activityId);
}
