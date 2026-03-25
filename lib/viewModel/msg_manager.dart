import 'package:ai_assitant/respository/chat_repository.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import '../database/app_database.dart';

class MessagesManager extends ChangeNotifier {
  final ChatRepository repository;

  //当前显示消息的会话
  int? _sessionId;
  int? get sessionId => _sessionId;

  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  MessagesManager({
    required this.repository
  });
  // 插入2条默认消息，调试用
  Future<void> insertDefaultMessage() async {
    if (_sessionId == null) return;

    final now = DateTime.now();
    await repository.insertMessage(
      ChatMessagesCompanion(
        sessionId: Value(_sessionId!),
        message: Value("TEST1: 新会话已创建"),
        role: Value("user"),
        timestamp: Value(now),
      ),
    );
    await repository.insertMessage(
      ChatMessagesCompanion(
        sessionId: Value(_sessionId!),
        message: Value("TEST2: 显示ai消息"),
        role: Value("ai"),
        timestamp: Value(now),
      ),
    );
    // 重新加载消息列表
    await loadMessages();

  }

  Future<int> insertMessage(String message, String role, {String? imagePath}) async {
  if (_sessionId == null) return -1;

  final now = DateTime.now();
  final id = await repository.insertMessage(
    ChatMessagesCompanion(
      sessionId: Value(_sessionId!),
      message: Value(message),
      role: Value(role),
      timestamp: Value(now),
      imagePath: imagePath != null ? Value(imagePath) : const Value.absent(),
    ),
  );

  // 重新加载消息列表
  await loadMessages();
  return id;
}

  // 更新指定消息的内容，流式显示用
  Future<void> updateMessageContent(int messageId, String newContent) async {
    await repository.updateMessageContent(messageId, newContent);

    // 更新本地缓存中的对应消息
    final index = _messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      _messages[index] = _messages[index].copyWith(message: newContent);
      notifyListeners();
    }
  }
  // 设置会话ID并加载消息
  Future<void> setSessionId(int newSessionId) async {
    // 如果会话ID未变化，不重复加载
    if (_sessionId == newSessionId) return;

    _sessionId = newSessionId;
    await loadMessages();
  }

  //加载信息
  Future<void> loadMessages() async {
    _isLoading = true;
    notifyListeners();

    try {
      print("尝试获取 sessionId = $_sessionId 的消息");
      _messages = await repository.getMessagesBySession(_sessionId!);
      print("成功加载消息数量: ${_messages.length}");
    } catch (e, stackTrace) {
      print("❌ 加载消息失败: $e");
      print("🔍 StackTrace:\n$stackTrace");
    }



    _isLoading = false;
    notifyListeners();
  }
}
