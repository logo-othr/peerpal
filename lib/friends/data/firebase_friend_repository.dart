import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peerpal/app/data/firestore/firestore_service.dart';
import 'package:peerpal/discover_feed/data/dto/peerpal_user_dto.dart';
import 'package:peerpal/discover_feed/data/dto/public_user_information_dto.dart';
import 'package:peerpal/discover_feed_v2/domain/peerpal_user.dart';
import 'package:peerpal/friends/domain/repository/friend_repository.dart';

class FirebaseFriendRepository implements FriendRepository {
  final FirestoreService _firestoreService;

  FirebaseFriendRepository({firestoreService})
      : _firestoreService = firestoreService;

  Future<void> sendFriendRequestToUser(PeerPALUser user) async {
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    Map<String, dynamic> data = {
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'fromId': currentUserId,
      'toId': user.id,
    };

    await _firestoreService.setDocument(
        collection: 'friendRequestNotifications', data: data);
  }

  Future<void> canceledFriendRequest(PeerPALUser userInformation) async {
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    Map<String, dynamic> data = {
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'fromId': currentUserId,
      'toId': userInformation.id,
    };

    await _firestoreService.setDocument(
        collection: 'canceledFriendRequests', data: data);
  }

  Future<void> friendRequestResponse(
      PeerPALUser userInformation, bool response) async {
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    Map<String, dynamic> data = {
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'fromId': currentUserId,
      'toId': userInformation.id,
      'response': response,
    };

    await _firestoreService.setDocument(
        collection: 'friendRequestResponse', data: data);
  }

  Stream<List<PeerPALUser>> getFriendList() async* {
    var currentList = <PeerPALUser>[];
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;

    Stream<QuerySnapshot> stream = _firestoreService
        .collection('friends')
        .where('fromId', isEqualTo: currentUserId)
        .snapshots();

    await for (QuerySnapshot querySnapshot in stream) {
      currentList.clear();
      for (var doc in querySnapshot.docs) {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestoreService
            .getDocument('publicUserData', doc['toId'])
            .get();

        var userDTO = PeerPALUserDTO(
            publicUserInformation:
                PublicUserInformationDTO.fromJson(userDoc.data()!));

        PeerPALUser friend = userDTO.toDomainObject();

        if (!currentList.contains(friend)) {
          currentList.add(friend);
        }
      }
      yield currentList;
    }
  }

  Stream<List<PeerPALUser>> getSentFriendRequestsFromUser() async* {
    var currentList = <PeerPALUser>[];
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;

    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('friendRequests')
        .where('fromId', isEqualTo: currentUserId)
        .snapshots();

    await for (QuerySnapshot querySnapshot in stream) {
      currentList.clear();
      for (var doc in querySnapshot.docs) {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('publicUserData')
            .doc(doc['toId'])
            .get();

        var userDTO = PeerPALUserDTO(
            publicUserInformation:
                PublicUserInformationDTO.fromJson(userDoc.data()!));

        PeerPALUser friend = userDTO.toDomainObject();

        if (!currentList.contains(friend)) {
          currentList.add(friend);
        }
      }
      yield currentList;
    }
  }

  Stream<List<PeerPALUser>> getFriendRequestsFromUser() async* {
    var currentList = <PeerPALUser>[];
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;

    Stream<QuerySnapshot> stream = _firestoreService
        .collection('friendRequests')
        .where('toId', isEqualTo: currentUserId)
        .snapshots();

    await for (QuerySnapshot querySnapshot in stream) {
      currentList.clear();
      for (var doc in querySnapshot.docs) {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestoreService
            .collection('publicUserData')
            .doc(doc['fromId'])
            .get() as DocumentSnapshot<Map<String, dynamic>>;

        var userDTO = PeerPALUserDTO(
            publicUserInformation:
                PublicUserInformationDTO.fromJson(userDoc.data()!));

        PeerPALUser friend = userDTO.toDomainObject();

        if (!currentList.contains(friend)) {
          currentList.add(friend);
        }
      }
      yield currentList;
    }
  }

  Stream<int> getFriendRequestsSize() async* {
    await for (var friendRequestList in getFriendRequestsFromUser()) {
      yield friendRequestList.length;
    }
  }
}
