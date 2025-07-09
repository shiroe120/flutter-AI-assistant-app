import 'package:ai_assitant/viewModel/session_manager.dart';
import 'package:ai_assitant/widgets/feature_list.dart';
import 'package:flutter/material.dart ';
import 'package:ai_assitant/themes/ui_constants.dart';
import 'package:ai_assitant/viewModel/msg_manager.dart';
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
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: sessionManager.sessions
                        .expand<Widget>((session) => [
                      ListTile(
                        title: Text(session.sessionName),
                        subtitle: Text(session.createdAt.toString()),
                        onTap: () async {
                          final messagesManager = Provider.of<MessagesManager>(context, listen: false);
                          await messagesManager.setSessionId(session.id);
                          Navigator.pop(context);
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
                      // Divider 后续你也可以封装成一个组件
                      Divider(
                        color: Theme.of(context).colorScheme.surface,
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                      ),
                    ])
                        .toList()
                      ..removeLast(), // 移除最后一个多余的 Divider
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