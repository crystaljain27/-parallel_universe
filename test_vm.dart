import 'package:parallel_universe/features/chat/presentation/manager/chat_view_model.dart';
import 'package:parallel_universe/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:parallel_universe/features/chat/data/repositories/chat_repository_impl.dart';

void main() async {
  final dataSource = ChatRemoteDataSource();
  final repo = ChatRepositoryImpl(dataSource);
  final vm = ChatViewModel(repo);

  vm.addListener(() {
    print('ViewModel updated -> messages: ${vm.messages.length}, isTyping: ${vm.isTyping}, canGenerate: ${vm.messages.isNotEmpty && !vm.isTyping}');
  });

  print('Starting test...');
  vm.startNewChat();
  await vm.sendMessage('Hello');
  
  // Wait for stream to finish
  await Future.delayed(Duration(seconds: 5));
  print('Test finished. Final state -> isTyping: ${vm.isTyping}');
}
