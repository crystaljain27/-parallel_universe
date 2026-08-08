import 'package:flutter/material.dart';
import 'package:parallel_universe/core/di/dependency_injection.dart';
import 'package:parallel_universe/core/routing/app_router.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final _viewModel = DI.chatListViewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetchSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Chat History')),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_viewModel.sessions.isEmpty) {
            return const Center(child: Text('No previous chats. Start a new one!'));
          }
          return ListView.builder(
            itemCount: _viewModel.sessions.length,
            itemBuilder: (context, index) {
              final session = _viewModel.sessions[index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.chat)),
                title: Text(session.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(session.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.chat, arguments: session.id);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRouter.chat);
        },
        icon: const Icon(Icons.add),
        label: const Text('New Chat'),
      ),
    );
  }
}
