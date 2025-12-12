import 'package:flutter/material.dart';
import 'package:bloodconnect/widgets/organisms/app_shell.dart';

class DonorDashboardPage extends StatefulWidget {
  const DonorDashboardPage({super.key});

  @override
  State<DonorDashboardPage> createState() => _DonorDashboardPageState();
}

class _DonorDashboardPageState extends State<DonorDashboardPage> {
  bool _available = true;
  DateTime _nextEligible = DateTime.now().add(const Duration(days: 56));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppShell(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Donor', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          SwitchListTile(
            value: _available,
            title: const Text('Available for donation'),
            subtitle: Text(
                'Next eligible: ${_nextEligible.toLocal().toString().split(' ').first}'),
            onChanged: (v) => setState(() => _available = v),
          ),
          const SizedBox(height: 12),
          Text('Incoming Requests', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          ...List.generate(
              2,
              (i) => Card(
                      child: ListTile(
                    title: Text('Urgent Request #$i - O-'),
                    subtitle: const Text('City Hospital'),
                    trailing: Wrap(spacing: 8, children: [
                      FilledButton(
                          onPressed: () {}, child: const Text('Accept')),
                      OutlinedButton(
                          onPressed: () {}, child: const Text('Decline')),
                    ]),
                  ))),
          const SizedBox(height: 12),
          Text('Donation History', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          ...List.generate(
              3,
              (i) => ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text('Donation #$i'),
                  subtitle: const Text('A+ • Completed'))),
        ]),
      ),
    );
  }
}
