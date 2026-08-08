import 'package:parallel_universe/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:parallel_universe/core/di/dependency_injection.dart';
import 'package:parallel_universe/features/chat/presentation/widgets/message_bubble.dart';
import 'package:parallel_universe/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:parallel_universe/features/chat/presentation/widgets/typing_indicator.dart';
import 'package:parallel_universe/features/chat/presentation/widgets/suggested_prompts.dart';

class ChatScreen extends StatefulWidget {
  final String? sessionId;
  const ChatScreen({super.key, this.sessionId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _viewModel = DI.chatViewModel;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    debugPrint("CHAT_SCREEN_LOADED");
    _viewModel.addListener(_scrollToBottom);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.sessionId != null) {
        _viewModel.initializeChat(widget.sessionId!);
      } else {
        _viewModel.startNewChat();
      }
    });
  }

  @override
  void dispose() {
    _viewModel.removeListener(_scrollToBottom);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RUNNING CHAT SCREEN'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) {
                final bool canGenerate = _viewModel.messages.isNotEmpty && !_viewModel.isTyping;
                debugPrint('Generate Button Rebuild -> messages: ${_viewModel.messages.length}, isTyping: ${_viewModel.isTyping}, canGenerate: $canGenerate');
                
                return FilledButton.icon(
                  onPressed: canGenerate ? () async {
                    final hasMemory = await DI.lifeInterviewViewModel.hasMemory();
                    if (!context.mounted) return;
                    
                    if (hasMemory) {
                      Navigator.pushNamed(
                        context, 
                        AppRouter.generateLoading, 
                        arguments: 'active_session'
                      );
                    } else {
                      Navigator.pushNamed(
                        context, 
                        AppRouter.lifeInterview,
                      );
                    }
                  } : null,
                  icon: const Icon(Icons.auto_awesome, size: 18),
                  label: const Text('Generate'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 16, top: 16),
                  itemCount: _viewModel.messages.length + (_viewModel.isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _viewModel.messages.length) {
                      return const Align(
                        alignment: Alignment.centerLeft,
                        child: TypingIndicator(),
                      );
                    }
                    return MessageBubble(message: _viewModel.messages[index]);
                  },
                ),
              ),
              if (_viewModel.messages.isEmpty)
                SuggestedPrompts(
                  onPromptSelected: (prompt) => _viewModel.sendMessage(prompt),
                ),
              ChatInputBar(
                onSend: (text) => _viewModel.sendMessage(text),
              ),
            ],
          );
        },
      ),
    );
  }
}
