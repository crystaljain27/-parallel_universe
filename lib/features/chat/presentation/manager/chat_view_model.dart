import 'package:flutter/material.dart';
import 'package:parallel_universe/features/chat/domain/entities/chat_message_entity.dart';
import 'package:parallel_universe/features/chat/domain/repositories/i_chat_repository.dart';

class ChatViewModel extends ChangeNotifier {
  final IChatRepository _repository;
  String _sessionId = '';

  ChatViewModel(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isTyping = false;
  bool get isTyping => _isTyping;

  List<ChatMessageEntity> _messages = [];
  List<ChatMessageEntity> get messages => _messages;

  Future<void> initializeChat(String sessionId) async {
    _sessionId = sessionId;
    _isLoading = true;
    notifyListeners();
    try {
      _messages = await _repository.getChatHistory(sessionId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startNewChat() {
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    _messages = [];
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMsg);
    _isTyping = true;
    notifyListeners();

    String currentAiResponse = '';
    final aiMsgId = (DateTime.now().millisecondsSinceEpoch + 1).toString();
    
    _messages.add(ChatMessageEntity(
      id: aiMsgId,
      text: currentAiResponse,
      isUser: false,
      timestamp: DateTime.now(),
    ));

    final stream = _repository.sendMessageStream(_sessionId, text);
    
    stream.listen(
      (chunk) {
        currentAiResponse += chunk;
        final index = _messages.indexWhere((m) => m.id == aiMsgId);
        if (index != -1) {
          _messages[index] = ChatMessageEntity(
            id: aiMsgId,
            text: currentAiResponse,
            isUser: false,
            timestamp: DateTime.now(),
          );
          notifyListeners();
        }
      },
      onDone: () {
        _isTyping = false;
        notifyListeners();
      },
    );
  }
}
