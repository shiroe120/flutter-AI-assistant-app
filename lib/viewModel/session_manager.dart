


import 'package:ai_assitant/database/app_database.dart';
import 'package:ai_assitant/respository/chat_repository.dart';
import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager extends ChangeNotifier{
  final ChatRepository repository;
  // 会话列表
  List<ChatSession> _sessions = [];
  List<ChatSession> get sessions => _sessions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  SessionManager({required this.repository});


  //修改会话名称
  Future<void> renameSession(int sessionId, String newName) async {
    final success = await repository.updateSessionName(sessionId, newName);
      // 更新本地列表
      final index = _sessions.indexWhere((s) => s.id == sessionId);
      if (index != -1) {
        final old = _sessions[index];
        _sessions[index] = ChatSession(
          id: old.id,
          userId: old.userId,
          sessionName: newName,
          createdAt: old.createdAt,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }
  }

  // 获取当前用户ID
  Future<int> _getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('currentUserId');
    print("当前获取到的 userId 是: $userId");
    if (userId == null) throw Exception("用户未登录");
    return userId;
  }

  // 创建新会话并插入
  Future<int> createNewSession() async {
    final userId = await _getCurrentUserId();
    final now = DateTime.now();
    final defaultName = "新会话 ${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}";

    final sessionId = await repository.insertChatSession(
      ChatSessionsCompanion(
        userId: Value(userId),
        sessionName: Value(defaultName),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),

    );

    await loadSessions(); // 重新加载列表
    return sessionId;
  }

  // 删除会话
  Future<void> deleteSession(int sessionId) async {
    await repository.deleteChatSession(sessionId);
    await loadSessions(); // 重新加载列表
  }

  // 加载会话
  Future<void> loadSessions() async {
    _isLoading = true;
    notifyListeners();

    final userId = await _getCurrentUserId();
    _sessions = await repository.getSessionsByUser(userId);

    _isLoading = false;
    notifyListeners();
  }

}