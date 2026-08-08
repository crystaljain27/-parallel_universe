import 'package:flutter/material.dart';
import 'package:parallel_universe/features/future_self/domain/entities/future_message_entity.dart';
import 'package:parallel_universe/features/future_self/domain/repositories/i_future_chat_repository.dart';

import 'package:parallel_universe/features/life_interview/domain/repositories/i_life_interview_repository.dart';

class FutureChatViewModel extends ChangeNotifier {
  final IFutureChatRepository _repository;
  final ILifeInterviewRepository _lifeInterviewRepository;

  FutureChatViewModel(this._repository, this._lifeInterviewRepository);

  String _universeId = '';
  String _universeName = '';
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isTyping = false;
  bool get isTyping => _isTyping;

  List<FutureMessageEntity> _messages = [];
  List<FutureMessageEntity> get messages => _messages;

  Future<void> initializeChat(String universeId, String universeName) async {
    _universeId = universeId;
    _universeName = universeName;
    _isLoading = true;
    notifyListeners();

    try {
      final history = await _repository.getChatHistory(universeId);
      
      if (history.isNotEmpty) {
        _messages = history;
      } else {
        _messages = [];
        final intro = await _repository.getIntroMessage(universeId, universeName);
        final introMsg = FutureMessageEntity(
          id: 'intro',
          text: intro,
          isUser: false,
          timestamp: DateTime.now(),
        );
        _messages.add(introMsg);
        await _repository.saveMessage(universeId, introMsg);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsg = FutureMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMsg);
    _isTyping = true;
    notifyListeners();
    
    // Save user message to local storage
    await _repository.saveMessage(_universeId, userMsg);

    String currentResponse = '';
    final aiMsgId = (DateTime.now().millisecondsSinceEpoch + 1).toString();
    
    _messages.add(FutureMessageEntity(
      id: aiMsgId,
      text: currentResponse,
      isUser: false,
      timestamp: DateTime.now(),
    ));

    final memory = await _lifeInterviewRepository.getSavedMemory();
    final stream = _repository.sendMessageStream(_universeId, _universeName, text, _messages, memory: memory);
    
    stream.listen(
      (chunk) {
        currentResponse += chunk;
        final index = _messages.indexWhere((m) => m.id == aiMsgId);
        if (index != -1) {
          _messages[index] = FutureMessageEntity(
            id: aiMsgId,
            text: currentResponse,
            isUser: false,
            timestamp: DateTime.now(),
          );
          notifyListeners();
        }
      },
      onDone: () async {
        _isTyping = false;
        notifyListeners();
        
        // Save the final AI response to local storage
        final index = _messages.indexWhere((m) => m.id == aiMsgId);
        if (index != -1) {
          await _repository.saveMessage(_universeId, _messages[index]);
        }
      },
    );
  }
}
