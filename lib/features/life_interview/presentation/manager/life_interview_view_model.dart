import 'package:flutter/material.dart';
import 'package:parallel_universe/features/chat/domain/entities/chat_message_entity.dart';
import 'package:parallel_universe/features/life_interview/domain/repositories/i_life_interview_repository.dart';

class LifeInterviewViewModel extends ChangeNotifier {
  final ILifeInterviewRepository _repository;

  LifeInterviewViewModel(this._repository);

  List<ChatMessageEntity> _messages = [];
  List<ChatMessageEntity> get messages => _messages;

  bool _isTyping = false;
  bool get isTyping => _isTyping;

  bool _isExtracting = false;
  bool get isExtracting => _isExtracting;

  int _questionCount = 0;
  final int _maxQuestions = 6; // Ask about 6 questions before extracting

  bool get isInterviewComplete => _questionCount >= _maxQuestions;

  Future<bool> hasMemory() async {
    final memory = await _repository.getSavedMemory();
    return memory != null && !memory.isEmpty;
  }

  void startInterview() {
    _messages = [
      ChatMessageEntity(
        id: 'intro',
        text: "Hi! Before I simulate your future, I'd like to know a little about your current life.\n\nWhat are you currently doing? Are you working or studying?",
        isUser: false,
        timestamp: DateTime.now(),
      )
    ];
    _questionCount = 0;
    _isExtracting = false;
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

    String currentResponse = '';
    final aiMsgId = (DateTime.now().millisecondsSinceEpoch + 1).toString();

    _messages.add(ChatMessageEntity(
      id: aiMsgId,
      text: currentResponse,
      isUser: false,
      timestamp: DateTime.now(),
    ));

    final stream = _repository.streamInterviewResponse(text, _messages);

    stream.listen(
      (chunk) {
        currentResponse += chunk;
        final index = _messages.indexWhere((m) => m.id == aiMsgId);
        if (index != -1) {
          _messages[index] = ChatMessageEntity(
            id: aiMsgId,
            text: currentResponse,
            isUser: false,
            timestamp: DateTime.now(),
          );
          notifyListeners();
        }
      },
      onDone: () {
        _isTyping = false;
        _questionCount++;
        notifyListeners();
      },
    );
  }

  Future<bool> extractAndFinish() async {
    _isExtracting = true;
    notifyListeners();

    final memory = await _repository.extractAndSaveMemory(_messages);
    
    _isExtracting = false;
    notifyListeners();
    
    return memory != null;
  }
}
