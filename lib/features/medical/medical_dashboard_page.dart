import 'package:flutter/material.dart';
import 'package:bloodconnect/widgets/organisms/app_shell.dart';

class MedicalDashboardPage extends StatefulWidget {
  const MedicalDashboardPage({super.key});

  @override
  State<MedicalDashboardPage> createState() => _MedicalDashboardPageState();
}

class _MedicalDashboardPageState extends State<MedicalDashboardPage> {
  String _group = 'O-';
  final _location = TextEditingController();
  final _units = TextEditingController(text: '1');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppShell(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Medical Staff', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Post Urgent Request', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _group,
                items: const [
                  DropdownMenuItem(value: 'O-', child: Text('O-')),
                  DropdownMenuItem(value: 'A+', child: Text('A+'))
                ],
                onChanged: (v) => setState(() => _group = v ?? _group),
              ),
              const SizedBox(height: 8),
              TextField(
                  controller: _location,
                  decoration: const InputDecoration(labelText: 'Location')),
              const SizedBox(height: 8),
              TextField(
                  controller: _units,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Units needed')),
              const SizedBox(height: 8),
              FilledButton(
                  onPressed: () {}, child: const Text('Trigger Alert')),
            ]),
          ),
          const SizedBox(height: 16),
          Text('Live Urgent Alerts', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          ...List.generate(
              3,
              (i) => ListTile(
                  leading: const Icon(Icons.warning, color: Colors.orange),
                  title: Text('O- needed at City Hospital #$i'),
                  subtitle: const Text('Critical • 2 units'))),
        ]),
      ),
    );
  }
}
