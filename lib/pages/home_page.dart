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
    _loadSessions();
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

              // 创建新会话
              final newSessionId = await sessionManager.createNewSession();
              await messagesManager.setSessionId(newSessionId);
            },
          ),
        ],

        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        automaticallyImplyLeading: false,
      ),

      //侧边栏
      drawer: Drawer(
        child: Consumer<SessionManager>(
          builder: (context, sessionManager, _) {
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
                      ListTile(
                        title: Text(session.sessionName),
                        subtitle: Text(session.createdAt.toString()),
                        onTap: () async {
                          final messagesManager = Provider.of<MessagesManager>(context, listen: false);
                          await messagesManager.setSessionId(session.id);
                          Navigator.pop(context);
                        },
                        onLongPress: () async {
                          // 弹出对话框输入新名称
                          final newName = await showDialog<String>(
                            context: context,
                            builder: (context) {
                              final controller = TextEditingController(text: session.sessionName);
                              return AlertDialog(
                                title: const Text('修改会话名称'),
                                content: TextField(
                                  controller: controller,
                                  decoration: const InputDecoration(
                                    hintText: '请输入新名称',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context), // 取消
                                    child: const Text('取消'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      final text = controller.text.trim();
                                      if (text.isNotEmpty) {
                                        Navigator.pop(context, text); // 返回新名称
                                      }
                                    },
                                    child: const Text('确定'),
                                  ),
                                ],
                              );
                            },
                          );

                          // 如果用户输入了新名称，则调用 renameSession
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