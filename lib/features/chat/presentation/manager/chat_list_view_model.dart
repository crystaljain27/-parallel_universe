import 'package:flutter/material.dart';
import 'package:parallel_universe/features/chat/domain/entities/chat_session_entity.dart';
import 'package:parallel_universe/features/chat/domain/repositories/i_chat_repository.dart';

class ChatListViewModel extends ChangeNotifier {
  final IChatRepository _repository;

  ChatListViewModel(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ChatSessionEntity> _sessions = [];
  List<ChatSessionEntity> get sessions => _sessions;

  Future<void> fetchSessions() async {
    _isLoading = true;
    notifyListeners();
    try {
      _sessions = await _repository.getChatSessions();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
