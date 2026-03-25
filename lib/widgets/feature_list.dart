import 'package:ai_assitant/themes/light_theme.dart';
import 'package:flutter/material.dart';

class FeatureList extends StatelessWidget {
  final void Function() onLogout;
  final void Function() onOpenSettings;

  const FeatureList({
    super.key,
    required this.onLogout,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          // 设置
          ListTile(
            leading: Icon(Icons.settings, color: Theme.of(context).colorScheme.primary),
            title: const Text('设置'),
            onTap: onOpenSettings,
            trailing: Icon(Icons.arrow_forward_ios, color: underSurface, size: 16),
          ),
          Divider(
            color: Theme.of(context).colorScheme.surface,
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
          // 退出登录
          ListTile(
            leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.primary),
            title: const Text('退出登录'),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
