import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/app/domain/analytics/analytics_repository.dart';
import 'package:peerpal/app/domain/analytics/analytics_service.dart';
import 'package:peerpal/app/domain/support_videos/support_video.dart';

class FirebaseAnalyticsRepository extends AnalyticsRepository {
  final AnalyticsService analyticsService;

  FirebaseAnalyticsRepository({required this.analyticsService});

  @override
  addPublicActivityClick(String userId, String timestamp, Activity activity) {
    analyticsService.addPublicActivityClick(userId, timestamp, activity);
  }

  @override
  addUserSearch(String userId, String timestamp, String searchQuery) {
    analyticsService.addUserSearch(userId, timestamp, searchQuery);
  }

  @override
  addVideoClick(String userId, String timestamp, SupportVideo supportVideo) {
    analyticsService.addVideoClick(userId, timestamp, supportVideo);
  }

  @override
  addAddActivityClick(String userId, String timestamp, String activityId) {
    analyticsService.addAddActivityClick(userId, timestamp, activityId);
  }
}
