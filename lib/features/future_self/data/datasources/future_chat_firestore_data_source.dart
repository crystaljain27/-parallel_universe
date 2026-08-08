import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:parallel_universe/features/future_self/domain/entities/future_message_entity.dart';

class FutureChatFirestoreDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  Future<List<FutureMessageEntity>> getChatHistory(String universeId) async {
    final uid = _uid;
    if (uid == null) {
      debugPrint("Cannot get chat history: User is not logged in.");
      return [];
    }

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('universes')
          .doc(universeId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return FutureMessageEntity(
          id: data['id'],
          text: data['text'],
          isUser: data['isUser'],
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      debugPrint("Error getting chat history from firestore: $e");
      return [];
    }
  }

  Future<void> saveMessage(String universeId, FutureMessageEntity message) async {
    final uid = _uid;
    if (uid == null) {
      debugPrint("Cannot save message: User is not logged in.");
      return;
    }

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('universes')
          .doc(universeId)
          .collection('messages')
          .doc(message.id)
          .set({
        'id': message.id,
        'text': message.text,
        'isUser': message.isUser,
        'timestamp': Timestamp.fromDate(message.timestamp),
      });
    } catch (e) {
      debugPrint("Error saving message to firestore: $e");
    }
  }
}
