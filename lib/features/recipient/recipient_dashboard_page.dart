import 'package:flutter/material.dart';
import 'package:bloodconnect/widgets/organisms/app_shell.dart';

class RecipientDashboardPage extends StatefulWidget {
  const RecipientDashboardPage({super.key});

  @override
  State<RecipientDashboardPage> createState() => _RecipientDashboardPageState();
}

class _RecipientDashboardPageState extends State<RecipientDashboardPage> {
  final _formKey = GlobalKey<FormState>();
  String _bloodGroup = 'A+';
  String _urgency = 'normal';
  final _notes = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppShell(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Recipient', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2))),
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create Request', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _bloodGroup,
                      decoration:
                          const InputDecoration(labelText: 'Blood group'),
                      items: _groups
                          .map(
                              (g) => DropdownMenuItem(value: g, child: Text(g)))
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _bloodGroup = v ?? _bloodGroup),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                        spacing: 8,
                        children: _urgencies
                            .map((u) => ChoiceChip(
                                label: Text(u),
                                selected: _urgency == u,
                                onSelected: (_) =>
                                    setState(() => _urgency = u)))
                            .toList()),
                    const SizedBox(height: 8),
                    TextFormField(
                        controller: _notes,
                        decoration: const InputDecoration(labelText: 'Notes'),
                        maxLines: 2),
                    const SizedBox(height: 12),
                    FilledButton(
                        onPressed: () {/* call service */},
                        child: const Text('Submit Request')),
                  ]),
            ),
          ),
          const SizedBox(height: 16),
          Text('My Requests', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (_, i) => Card(
              child: ListTile(
                title: Text('Request #$i - A+'),
                subtitle: const Text('Status: open'),
                trailing: Wrap(spacing: 8, children: [
                  OutlinedButton(onPressed: () {}, child: const Text('Edit')),
                  TextButton(onPressed: () {}, child: const Text('Cancel')),
                ]),
              ),
            ),
          )
        ]),
      ),
    );
  }

  List<String> get _groups =>
      const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  List<String> get _urgencies => const ['normal', 'high', 'critical'];
}
