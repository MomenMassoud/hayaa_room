import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseService {
  // Store data in parent collection
  Future<void> storeDataInParentCollection({
    required String collectionName,
    required Map<String, dynamic> data,
    required String docId,
  }) async {
    try {
      DocumentReference docmentRef =
          FirebaseFirestore.instance.collection(collectionName).doc(docId);
      await docmentRef.set(data);
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(
            "an error ocure with status code ${e.code} and error is ${e.message}");
      } else {
        throw Exception(
            "Opps An Error Ocured Please Try Again Later  ${e.toString()}");
      }
    }
  }

  // Read data from parent collection
  Future<List<Map<String, dynamic>>> readDataFromParentCollection(
      {required String collectionName}) async {
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection(collectionName);
      QuerySnapshot querySnapshot = await collectionRef.get();
      List<Map<String, dynamic>> dataList = [];
      querySnapshot.docs.forEach((doc) {
        dataList.add(doc.data() as Map<String, dynamic>);
      });
      return dataList;
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(
            "an error ocure with status code ${e.code} and error is ${e.message}");
      } else {
        throw Exception(
            "Opps An Error Ocured Please Try Again Later  ${e.toString()}");
      }
    }
  }

  // Update data in parent collection
  Future<void> updateDataInParentCollection({
    required String collectionName,
    required String documentId,
    required Map<String, dynamic> updatedData,
  }) async {
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection(collectionName);
      DocumentReference documentRef = collectionRef.doc(documentId);
      await documentRef.update(updatedData);
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(
            "an error ocure with status code ${e.code} and error is ${e.message}");
      } else {
        throw Exception(
            "Opps An Error Ocured Please Try Again Later  ${e.toString()}");
      }
    }
  }

  // Delete data from parent collection
  Future<void> deleteDataFromParentCollection({
    required String collectionName,
    required String documentId,
  }) async {
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection(collectionName);
      DocumentReference documentRef = collectionRef.doc(documentId);
      await documentRef.delete();
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(
            "an error ocure with status code ${e.code} and error is ${e.message}");
      } else {
        throw Exception(
            "Opps An Error Ocured Please Try Again Later  ${e.toString()}");
      }
    }
  }

  // Store data in subcollection
  Future<void> storeDataInSubcollection({
    required String parentCollectionName,
    required String parentDocumentId,
    required String subcollectionName,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      CollectionReference parentCollectionRef =
          FirebaseFirestore.instance.collection(parentCollectionName);
      DocumentReference parentDocumentRef =
          parentCollectionRef.doc(parentDocumentId);
      CollectionReference subcollectionRef =
          parentDocumentRef.collection(subcollectionName);
      DocumentReference documentRef = subcollectionRef.doc(documentId);

      await documentRef.set(data);
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(
            "an error ocure with status code ${e.code} and error is ${e.message}");
      } else {
        throw Exception(
            "Opps An Error Ocured Please Try Again Later  ${e.toString()}");
      }
    }
  }

  // Read data from subcollection
  Future<List<Map<String, dynamic>>> readDataFromSubcollection({
    required String parentCollectionName,
    required String parentDocumentId,
    required String subcollectionName,
  }) async {
    try {
      CollectionReference parentCollectionRef =
          FirebaseFirestore.instance.collection(parentCollectionName);
      DocumentReference parentDocumentRef =
          parentCollectionRef.doc(parentDocumentId);
      CollectionReference subcollectionRef =
          parentDocumentRef.collection(subcollectionName);
      QuerySnapshot querySnapshot = await subcollectionRef.get();
      List<Map<String, dynamic>> dataList = [];
      querySnapshot.docs.forEach((doc) {
        dataList.add(doc.data() as Map<String, dynamic>);
      });
      return dataList;
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(
            "an error ocure with status code ${e.code} and error is ${e.message}");
      } else {
        throw Exception(
            "Opps An Error Ocured Please Try Again Later  ${e.toString()}");
      }
    }
  }

  Future<List<String>> readIdsFromSubcollection({
    required String parentCollectionName,
    required String parentDocumentId,
    required String subcollectionName,
  }) async {
    try {
      CollectionReference parentCollectionRef =
          FirebaseFirestore.instance.collection(parentCollectionName);
      DocumentReference parentDocumentRef =
          parentCollectionRef.doc(parentDocumentId);
      CollectionReference subcollectionRef =
          parentDocumentRef.collection(subcollectionName);
      QuerySnapshot querySnapshot = await subcollectionRef.get();
      List<String> dataList = [];
      querySnapshot.docs.forEach((doc) {
        dataList.add(doc.id);
      });
      return dataList;
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(
            "an error ocure with status code ${e.code} and error is ${e.message}");
      } else {
        throw Exception(
            "Opps An Error Ocured Please Try Again Later  ${e.toString()}");
      }
    }
  }

  // Update data in subcollection
  Future<void> updateDataInSubcollection({
    required String parentCollectionName,
    required String parentDocumentId,
    required String subcollectionName,
    required String documentId,
    required Map<String, dynamic> updatedData,
  }) async {
    try {
      CollectionReference parentCollectionRef =
          FirebaseFirestore.instance.collection(parentCollectionName);
      DocumentReference parentDocumentRef =
          parentCollectionRef.doc(parentDocumentId);
      CollectionReference subcollectionRef =
          parentDocumentRef.collection(subcollectionName);
      DocumentReference documentRef = subcollectionRef.doc(documentId);
      await documentRef.update(updatedData);
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(
            "an error ocure with status code ${e.code} and error is ${e.message}");
      } else {
        throw Exception(
            "Opps An Error Ocured Please Try Again Later  ${e.toString()}");
      }
    }
  }

  // Delete data from subcollection
  Future<void> deleteDataFromSubcollection({
    required String parentCollectionName,
    required String parentDocumentId,
    required String subcollectionName,
    required String documentId,
  }) async {
    try {
      CollectionReference parentCollectionRef =
          FirebaseFirestore.instance.collection(parentCollectionName);
      DocumentReference parentDocumentRef =
          parentCollectionRef.doc(parentDocumentId);
      CollectionReference subcollectionRef =
          parentDocumentRef.collection(subcollectionName);
      DocumentReference documentRef = subcollectionRef.doc(documentId);
      await documentRef.delete();
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(
            "an error ocure with status code ${e.code} and error is ${e.message}");
      } else {
        throw Exception(
            "Opps An Error Ocured Please Try Again Later  ${e.toString()}");
      }
    }
  }

  // this stream to git tow sub colections

  Stream<List<String>> getIdsFromSubcollectionsStream({
    required String parentCollectionName,
    required String parentDocumentId,
    required List<String> subcollectionNames,
  }) {
    FirebaseAuth _auth = FirebaseAuth.instance;

    // Create a reference to the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a List of subcollection streams
    List<Stream<List<String>>> subcollectionStreams =
        subcollectionNames.map((subcollectionName) {
      return firestore
          .collection(parentCollectionName)
          .doc(parentDocumentId)
          .collection(subcollectionName)
          .snapshots()
          .map((QuerySnapshot snapshot) {
        List<String> ids = snapshot.docs.map((doc) => doc.id).toList();
        return ids;
      });
    }).toList();

    // Merge the subcollection streams into a single stream
    Stream<List<String>> mergedStream = MergeStream(subcollectionStreams);

    return mergedStream;
  }
}
