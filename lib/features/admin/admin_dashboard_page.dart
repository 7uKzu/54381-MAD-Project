import 'package:flutter/material.dart';
import 'package:bloodconnect/widgets/organisms/app_shell.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppShell(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Admin', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text('Pending Registrations', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          ...List.generate(
              3,
              (i) => Card(
                      child: ListTile(
                    leading: const Icon(Icons.person_add),
                    title: Text('User #$i'),
                    subtitle: const Text('Role: Donor'),
                    trailing: Wrap(spacing: 8, children: [
                      FilledButton(
                          onPressed: () {}, child: const Text('Approve')),
                      OutlinedButton(
                          onPressed: () {}, child: const Text('Reject')),
                    ]),
                  ))),
          const SizedBox(height: 16),
          Text('Audit Logs', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          ...List.generate(
              5,
              (i) => ListTile(
                  leading: const Icon(Icons.receipt_long),
                  title: Text('Action #$i'),
                  subtitle: const Text('Details here...'))),
        ]),
      ),
    );
  }
}
