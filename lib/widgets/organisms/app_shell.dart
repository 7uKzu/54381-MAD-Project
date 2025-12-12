import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bloodconnect/providers/auth_provider.dart';
import 'package:bloodconnect/providers/alerts_provider.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(),
      body: SafeArea(child: child),
    );
  }
}

class AppTopBar extends StatefulWidget implements PreferredSizeWidget {
  const AppTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  State<AppTopBar> createState() => _AppTopBarState();
}

class _AppTopBarState extends State<AppTopBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    return Container(
      height: widget.preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      child: Row(children: [
        Text('BloodConnect', style: theme.textTheme.titleLarge),
        const Spacer(),
        if (auth.isLoggedIn) ...[
          Semantics(
            label: 'Alerts',
            button: true,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _openAlerts(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                child:
                    Icon(Icons.notifications, color: theme.colorScheme.primary),
              ),
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            tooltip: 'User menu',
            onSelected: (v) async {
              if (v == 'logout') {
                await context.read<AuthProvider>().logout();
                if (mounted)
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
            child: CircleAvatar(
                radius: 16,
                child: Text(
                    auth.user?.fullName.substring(0, 1).toUpperCase() ?? '?')),
          ),
        ],
      ]),
    );
  }

  void _openAlerts(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        final alerts = ctx.watch<AlertsProvider>().alerts;
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: alerts.length,
          separatorBuilder: (_, __) => Divider(
              height: 1,
              color: Theme.of(ctx).colorScheme.outline.withValues(alpha: 0.2)),
          itemBuilder: (_, i) {
            final a = alerts[i];
            return ListTile(
              title: Text(a.title),
              subtitle: Text(a.message),
              leading: Icon(a.type == 'urgent' ? Icons.warning : Icons.info,
                  color: a.type == 'urgent'
                      ? Colors.orange
                      : Theme.of(ctx).colorScheme.primary),
            );
          },
        );
      },
    );
  }
}
