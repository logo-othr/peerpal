import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({required FirebaseFirestore firestore})
      : _firestore = firestore;

  Future<void> setDocument(
      {required String collection,
      required String? docId,
      required Map<String, dynamic> data}) async {
    try {
      await _firestore
          .collection(collection)
          .doc(docId) // If docId is null, Firestore will generate a unique ID
          .set(data);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  CollectionReference collection(String path) {
    return _firestore.collection(path);
  }
}
