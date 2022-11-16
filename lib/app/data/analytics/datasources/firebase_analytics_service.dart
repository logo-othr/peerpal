import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/app/data/analytics/dto/analytic_add_activity_click_dto.dart';
import 'package:peerpal/app/data/analytics/dto/analytic_public_activity_click_dto.dart';
import 'package:peerpal/app/data/analytics/dto/analytic_user_search_dto.dart';
import 'package:peerpal/app/data/analytics/dto/analytic_video_click_dto.dart';
import 'package:peerpal/app/domain/analytics/analytics_service.dart';
import 'package:peerpal/app/domain/support_videos/support_video.dart';
import 'package:peerpal/repository/contracts/user_database_contract.dart';

class FirebaseAnalyticsService extends AnalyticsService {
  @override
  addPublicActivityClick(
      String userId, String timestamp, Activity activity) async {
    AnalyticPublicActivityClickDTO analyticPublicActivityClickDTO =
        AnalyticPublicActivityClickDTO(
            userId: userId, timestamp: timestamp, activityDTO: activity);
    await FirebaseFirestore.instance
        .collection(UserDatabaseContract.analytics_public_activity_click)
        .doc()
        .set(analyticPublicActivityClickDTO.toJson());
  }

  @override
  addUserSearch(String userId, String timestamp, String searchQuery) async {
    AnalyticUserSearchDTO analyticUserSearchDTO = AnalyticUserSearchDTO(
        userId: userId, timestamp: timestamp, searchQuery: searchQuery);
    await FirebaseFirestore.instance
        .collection(UserDatabaseContract.analytics_user_search)
        .doc()
        .set(analyticUserSearchDTO.toJson());
  }

  @override
  addVideoClick(
      String userId, String timestamp, SupportVideo supportVideo) async {
    AnalyticVideoClickDTO analyticVideoClickDTO = AnalyticVideoClickDTO(
        userId: userId, timestamp: timestamp, supportVideo: supportVideo);
    await FirebaseFirestore.instance
        .collection(UserDatabaseContract.analytics_video_click)
        .doc()
        .set(analyticVideoClickDTO.toJson());
  }

  @override
  addAddActivityClick(
      String userId, String timestamp, String activityId) async {
    AnalyticAddActivityClickDTO analyticVideoClickDTO =
        AnalyticAddActivityClickDTO(
            userId: userId, timestamp: timestamp, activityId: activityId);
    await FirebaseFirestore.instance
        .collection(UserDatabaseContract.analytics_add_activity_click)
        .doc()
        .set(analyticVideoClickDTO.toJson());
  }
}
