import 'package:flutter/material.dart';
import 'package:parallel_universe/core/di/dependency_injection.dart';
import 'package:parallel_universe/features/universe_generation/domain/entities/generated_universe_entity.dart';
import 'package:parallel_universe/features/future_self/presentation/widgets/future_message_bubble.dart';
import 'package:parallel_universe/features/future_self/presentation/widgets/future_suggested_questions.dart';
import 'package:parallel_universe/features/future_self/presentation/widgets/waveform_placeholder.dart';
import 'package:parallel_universe/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:parallel_universe/core/widgets/safe_network_image.dart';

class FutureChatScreen extends StatefulWidget {
  final GeneratedUniverseEntity universe;
  const FutureChatScreen({super.key, required this.universe});

  @override
  State<FutureChatScreen> createState() => _FutureChatScreenState();
}

class _FutureChatScreenState extends State<FutureChatScreen> {
  final _viewModel = DI.futureChatViewModel;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_scrollToBottom);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.initializeChat(widget.universe.id, widget.universe.name);
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
      body: Column(
        children: [
          _buildHeroHeader(context),
          Expanded(
            child: ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) {
                if (_viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 16, top: 8),
                  itemCount: _viewModel.messages.length + (_viewModel.isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _viewModel.messages.length) {
                      return const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: WaveformPlaceholder(),
                        ),
                      );
                    }
                    return FutureMessageBubble(message: _viewModel.messages[index]);
                  },
                );
              },
            ),
          ),
          ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) {
              if (_viewModel.messages.length == 1 && !_viewModel.isTyping) {
                return FutureSuggestedQuestions(
                  onSelect: (q) => _viewModel.sendMessage(q),
                );
              }
              return const SizedBox();
            }
          ),
          ChatInputBar(
            onSend: (text) => _viewModel.sendMessage(text),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: _scrollToBottom,
        child: const Icon(Icons.arrow_downward),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'universe_${widget.universe.id}',
            child: SafeNetworkImage(
              imageUrl: widget.universe.coverImage,
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.5),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      BackButton(color: Colors.white, onPressed: () => Navigator.pop(context)),
                      const Text(
                        'Future Self',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '${widget.universe.name} You',
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
