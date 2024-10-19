import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreServices {
  FirestoreServices._();

  static final instance = FirestoreServices._();

  final _fireStore = FirebaseFirestore.instance;

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final reference = _fireStore.doc(path);
    debugPrint('Request Data: $data');
    await reference.set(data);
  }

  Future<void> deleteData({required String path}) async {
    final reference = _fireStore.doc(path);
    debugPrint('Path: $path');
    await reference.delete();
  }

  Stream<T> documentsStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentId) builder,
  }) {
    final reference = _fireStore.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }

  Stream<List<T>> collectionsStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentId) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query query = _fireStore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map(
            (snapshot) =>
            builder(
              snapshot.data() as Map<String, dynamic>,
              snapshot.id,
            ),
      )
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Future<Map<String, dynamic>?> getDocument({required String path}) async {
    try {
      final docSnapshot = await _fireStore.doc(path).get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get document: ${e.toString()}');
    }
  }

  Future<List<T>> getCollection<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) async {
    Query query = _fireStore.collection(path);
    query = queryBuilder?.call(query) ?? query;

    try {
      final snapshots = await query.get();

      List<T> result = List.generate(
        snapshots.docs.length,
            (index) {
          final snapshot = snapshots.docs[index];
          return builder(snapshot.data() as Map<String, dynamic>, snapshot.id);
        },
      ).whereType<T>().toList();

      if (sort != null) {
        result.sort(sort);
      }

      return result;
    } catch (e) {
      throw Exception('Failed to fetch documents: $e');
    }
  }
}
