import 'package:flutter/material.dart';
import 'package:bloodconnect/widgets/organisms/app_shell.dart';

class TechnicianDashboardPage extends StatelessWidget {
  const TechnicianDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppShell(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Technician', style: theme.textTheme.headlineSmall),
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
              Text('Confirm Donation', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                  decoration: const InputDecoration(labelText: 'Donation ID')),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                  value: 'A+',
                  items: const [
                    DropdownMenuItem(value: 'A+', child: Text('A+')),
                    DropdownMenuItem(value: 'O-', child: Text('O-')),
                  ],
                  onChanged: (_) {}),
              const SizedBox(height: 8),
              FilledButton(
                  onPressed: () {},
                  child: const Text('Confirm & Add to Inventory')),
            ]),
          ),
          const SizedBox(height: 16),
          Text('Today\'s Donations', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          DataTable(columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Donor')),
            DataColumn(label: Text('Group')),
            DataColumn(label: Text('Status')),
          ], rows: const [
            DataRow(cells: [
              DataCell(Text('123')),
              DataCell(Text('Alice')),
              DataCell(Text('A+')),
              DataCell(Text('Pending'))
            ]),
            DataRow(cells: [
              DataCell(Text('124')),
              DataCell(Text('Bob')),
              DataCell(Text('O-')),
              DataCell(Text('Confirmed'))
            ]),
          ])
        ]),
      ),
    );
  }
}
