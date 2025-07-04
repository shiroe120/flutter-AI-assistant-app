import 'package:ai_assitant/respository/chat_repository.dart';
import 'package:flutter/material.dart';
import 'database/app_database.dart';

class MessagesManager extends ChangeNotifier {
  final ChatRepository repository;
  final int sessionId;

  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  MessagesManager({
    required this.repository,
    required this.sessionId,
  });

  //加载信息
  Future<void> loadMessages() async {
    _isLoading = true;
    notifyListeners();

    _messages = await repository.getMessagesBySession(sessionId);

    _isLoading = false;
    notifyListeners();
  }

}
