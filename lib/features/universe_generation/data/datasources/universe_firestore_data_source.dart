import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parallel_universe/features/universe_generation/domain/entities/generated_universe_entity.dart';
import 'package:flutter/foundation.dart';

class UniverseFirestoreDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  Future<void> saveUniverse(GeneratedUniverseEntity universe) async {
    final uid = _uid;
    if (uid == null) {
      debugPrint("Cannot save universe to firestore: User is not logged in.");
      return;
    }

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('universes')
          .doc(universe.id)
          .set(universe.toJson());
    } catch (e) {
      debugPrint("Error saving universe to firestore: $e");
    }
  }

  Future<List<GeneratedUniverseEntity>> getHistory() async {
    final uid = _uid;
    if (uid == null) {
      debugPrint("Cannot get history from firestore: User is not logged in.");
      return [];
    }

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('universes')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => GeneratedUniverseEntity.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint("Error getting history from firestore: $e");
      return [];
    }
  }
}
