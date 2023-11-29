import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:peerpal/app/data/user_database_contract.dart';
import 'package:peerpal/app_logger.dart';

class DeviceTokenService {
  final String REGISTER_DEVICE_TOKEN_ERROR =
      "An error occurred while registering the device token. ";
  final String REMOVE_DEVICE_TOKEN_ERROR =
      "An error occurred while removing the device token. ";
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> unregisterDeviceToken() async {
    var currentUserId = _firebaseAuth.currentUser!.uid;
    logger.i("Removing the device token...");
    FirebaseFirestore.instance
        .collection(UserDatabaseContract.serverDeleteDeviceTokenQueue)
        .doc()
        .set({UserDatabaseContract.userId: currentUserId}).onError((error,
                stackTrace) =>
            logger.e("${REMOVE_DEVICE_TOKEN_ERROR}. Error: ${error.toString()} "
                "Stacktrace: ${stackTrace.toString()}"));
  }

  Future<void> registerDeviceToken() async {
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseMessaging.instance.getToken().then((token) {
      FirebaseFirestore.instance
          .collection(UserDatabaseContract.serverUpdateDeviceTokenQueue)
          .doc()
          .set({
        UserDatabaseContract.userId: currentUserId,
        UserDatabaseContract.deviceToken: token
      }).onError((error, stackTrace) => logger
              .e("${REGISTER_DEVICE_TOKEN_ERROR}.  Error: ${error.toString()} "
                  "Stacktrace: ${stackTrace.toString()}"));
    }).catchError((error) {
      logger.e(
          "${REGISTER_DEVICE_TOKEN_ERROR}. Error: ${error.payload.toString()}");
    });
  }
}
