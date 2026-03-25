import 'package:ai_assitant/viewModel/session_manager.dart';
import 'package:ai_assitant/widgets/feature_list.dart';
import 'package:flutter/material.dart ';
import 'package:ai_assitant/themes/ui_constants.dart';
import 'package:ai_assitant/viewModel/msg_manager.dart';
import 'package:provider/provider.dart';

import '../widgets/chat_input_bar.dart';
import '../widgets/chat_message_list.dart';
import 'chat_page.dart';
import 'debug.dart';
//home page
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();



  @override
  void initState() {
    super.initState();

    // 延迟执行，保证 context 可用
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final sessionManager = Provider.of<SessionManager>(context, listen: false);
      final msgManager = Provider.of<MessagesManager>(context, listen: false);

      // 先加载已有会话
      await sessionManager.loadSessions();

      int? targetSessionId;

      // 找到第一个没有消息的会话
      for (var session in sessionManager.sessions) {
        final messages = await msgManager.repository.getMessagesBySession(session.id);
        if (messages.isEmpty) {
          targetSessionId = session.id;
          break;
        }
      }

      if (targetSessionId == null) {
        // 如果没有空会话，则创建新会话
        targetSessionId = await sessionManager.createNewSession();
      }

      // 设置 msgManager 的 sessionId
      await msgManager.setSessionId(targetSessionId);

      // 手动触发 rebuild，确保 Drawer 更新
      setState(() {});
    });
  }

  Future<void> _loadSessions() async {
    await Provider.of<SessionManager>(context, listen: false).loadSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        //icon button to open drawer
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu,),
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          //icon button to create new session
          IconButton(
            icon: const Icon(Icons.add),
            color: Theme.of(context).colorScheme.primary,
            onPressed: () async {
              final sessionManager = Provider.of<SessionManager>(context, listen: false);
              final messagesManager = Provider.of<MessagesManager>(context, listen: false);

              // 加载已有会话
              await sessionManager.loadSessions();

              int? targetSessionId;

              // 找到第一个没有消息的会话
              for (var session in sessionManager.sessions) {
                final messages = await messagesManager.repository.getMessagesBySession(session.id);
                if (messages.isEmpty) {
                  targetSessionId = session.id;
                  break;
                }
              }

              if (targetSessionId == null) {
                // 如果没有空会话，则创建新会话
                targetSessionId = await sessionManager.createNewSession();
              }

              // 设置 msgManager 的 sessionId
              await messagesManager.setSessionId(targetSessionId);
            },
          ),

        ],

        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        automaticallyImplyLeading: false,
      ),

      //侧边栏
      drawer: Drawer(
        child: Consumer2<SessionManager, MessagesManager>(
          builder: (context, sessionManager, msgManager,_) {
            return ListView(
              children: [
                // hint text
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 0, left: 16),
                  child: Text(
                    "更多",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                // Drawer header
                FeatureList(
                    onLogout: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    onOpenSettings: () {
                      Navigator.pushNamed(context, '/setting');
                    }
                    ),

                // hint text
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 0, left: 16),
                  child: Text(
                    "会话列表",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                // 会话列表
                Container(
                  constraints: const BoxConstraints(minHeight: 100),
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // 或 MainAxisSize.max 视情况
                    children: sessionManager.sessions.isEmpty
                        ? [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          "暂无会话",
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]
                        : sessionManager.sessions
                        .expand<Widget>((session) => [
                          // 用container包裹了listTile
                      Container(
                        decoration: BoxDecoration(
                          color: msgManager.sessionId == session.id
                              ? Theme.of(context).colorScheme.surface // 当前会话
                              : Theme.of(context).colorScheme.onPrimary, // 其他会话
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: ListTile(
                          title: Text(session.sessionName),
                          subtitle: Text(session.createdAt.toString().substring(0, 16)),
                          onTap: () async {
                            final messagesManager =
                            Provider.of<MessagesManager>(context, listen: false);
                            await messagesManager.setSessionId(session.id);
                            Navigator.pop(context);
                          },
                          onLongPress: () async {
                            // 弹出修改名称逻辑保持原样
                            final newName = await showDialog<String>(
                              context: context,
                              builder: (context) {
                                final controller =
                                TextEditingController(text: session.sessionName);
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  title: const Text('修改会话名称'),
                                  backgroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                                  content: TextField(
                                    controller: controller,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      hintText: '请输入新名称',
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: Theme.of(context).colorScheme.surface,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: Theme.of(context).colorScheme.primary,
                                          width: 1,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Theme.of(context).colorScheme.surface,
                                    ),
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              side: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                width: 1,
                                              ),
                                            ),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text('取消'),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () {
                                              final text =
                                              controller.text.trim();
                                              if (text.isNotEmpty) {
                                                Navigator.of(context).pop(text);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        '输入内容不能为空')));
                                              }
                                            },
                                            child: const Text(
                                              '确定',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );

                            if (newName != null && newName.isNotEmpty) {
                              await sessionManager.renameSession(session.id, newName);
                            }
                          },
                          trailing: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await sessionManager.deleteSession(session.id);
                              await _loadSessions();
                            },
                          ),
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.surface,
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                      ),
                    ])
                        .toList()
                      ..removeLast(),

                  ),

                ),
              ],
            );
          },
        ),
      ),

      body: ChatPage(),
    );
  }
}