import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parallel_universe/features/life_interview/presentation/manager/life_interview_view_model.dart';
import 'package:parallel_universe/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:parallel_universe/features/chat/presentation/widgets/message_bubble.dart';
import 'package:parallel_universe/features/chat/presentation/widgets/typing_indicator.dart';
import 'package:parallel_universe/features/universe_generation/presentation/pages/generation_loading_screen.dart';

class LifeInterviewScreen extends StatefulWidget {
  const LifeInterviewScreen({super.key});

  @override
  State<LifeInterviewScreen> createState() => _LifeInterviewScreenState();
}

class _LifeInterviewScreenState extends State<LifeInterviewScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LifeInterviewViewModel>().startInterview();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Career Coach'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: Consumer<LifeInterviewViewModel>(
        builder: (context, viewModel, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      itemCount: viewModel.messages.length + (viewModel.isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == viewModel.messages.length) {
                          return const TypingIndicator();
                        }
                        final msg = viewModel.messages[index];
                        return MessageBubble(
                          message: msg,
                        );
                      },
                    ),
                  ),
                  
                  if (viewModel.isInterviewComplete && !viewModel.isExtracting)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final success = await viewModel.extractAndFinish();
                          if (success && context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => GenerationLoadingScreen(sessionId: DateTime.now().millisecondsSinceEpoch.toString())),
                            );
                          }
                        },
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text('Generate My Futures'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                  if (!viewModel.isInterviewComplete && !viewModel.isExtracting)
                    ChatInputBar(
                      onSend: viewModel.sendMessage,
                    ),
                ],
              ),
              if (viewModel.isExtracting)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          "Extracting Smart Memory...",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
