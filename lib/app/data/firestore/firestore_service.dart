import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({required FirebaseFirestore firestore})
      : _firestore = firestore;

  DocumentReference<Map<String, dynamic>> getDocument(
      String collectionName, String docId) {
    return _firestore.collection(collectionName).doc(docId);
  }

  Future<void> setDocumentData(
      DocumentReference<Object?> document, Map<String, dynamic> data) async {
    await document.set(data, SetOptions(merge: true));
  }

  Future<void> setDocument(
      {required String collection,
      String? docId,
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

  CollectionReference<Map<String, dynamic>> collection(String path) {
    return _firestore.collection(path);
  }

  Stream<List<T>> convertSnapshotStreamToModelListStream<T>(
      Stream<QuerySnapshot> querySnapshotStream,
      T Function(Map<String, dynamic>) fromJsonFunc) async* {
    List<T> list = <T>[];
    await for (QuerySnapshot querySnapshot in querySnapshotStream) {
      list.clear();
      querySnapshot.docs.forEach((document) {
        var documentData = document.data() as Map<String, dynamic>;
        var item = fromJsonFunc(documentData);
        list.add(item);
      });
      yield list;
    }
  }
}
