import 'package:ai_assitant/session_manager.dart';
import 'package:flutter/material.dart ';
import 'package:ai_assitant/themes/ui_constants.dart';
import 'package:ai_assitant/msg_manager.dart';
import 'package:provider/provider.dart';

import '../widgets/chat_input_bar.dart';
import '../widgets/chat_message_list.dart';
import 'chat_page.dart';
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
      appBar: AppBar(
        //icon button to open drawer
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          //icon button to create new session
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final sessionManager = Provider.of<SessionManager>(context, listen: false);
              final messagesManager = Provider.of<MessagesManager>(context, listen: false);

              // 创建新会话
              final newSessionId = await sessionManager.createNewSession();
              await messagesManager.setSessionId(newSessionId);
            },
          ),
        ],

        backgroundColor: Theme.of(context).colorScheme.primary,
        automaticallyImplyLeading: false,
      ),
      drawer: Drawer(
        child: Consumer<SessionManager>(
          builder: (context, sessionManager, _) {
            return ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text(
                    'AI Assistant',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 24,
                    ),
                  ),
                ),
                ...sessionManager.sessions.map((session) {
                  return ListTile(

                    title: Text(session.sessionName),
                    subtitle: Text(session.createdAt.toString()),
                    onTap: () async {
                      final messagesManager = Provider.of<MessagesManager>(context, listen: false);

                      // 切换会话
                      await messagesManager.setSessionId(session.id);
                      Navigator.pop(context); // 关闭 Drawer
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            icon: const Icon(Icons.edit),
                          onPressed: () {}
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await sessionManager.deleteSession(session.id);
                            // 重新加载会话列表
                            await _loadSessions();
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
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