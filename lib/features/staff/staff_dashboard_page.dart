import 'package:flutter/material.dart';
import 'package:bloodconnect/widgets/organisms/app_shell.dart';

class StaffDashboardPage extends StatefulWidget {
  const StaffDashboardPage({super.key});

  @override
  State<StaffDashboardPage> createState() => _StaffDashboardPageState();
}

class _StaffDashboardPageState extends State<StaffDashboardPage> {
  DateTime? _date;
  TimeOfDay? _time;
  final _notes = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppShell(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Staff', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Row(children: [
            OutlinedButton(
                onPressed: _pickDate,
                child: Text(_date == null
                    ? 'Pick date'
                    : _date!.toLocal().toString().split(' ').first)),
            const SizedBox(width: 8),
            OutlinedButton(
                onPressed: _pickTime,
                child:
                    Text(_time == null ? 'Pick time' : _time!.format(context))),
          ]),
          const SizedBox(height: 8),
          TextField(
              controller: _notes,
              decoration: const InputDecoration(labelText: 'Notes')),
          const SizedBox(height: 8),
          FilledButton(
              onPressed: () {}, child: const Text('Schedule Appointment')),
          const SizedBox(height: 16),
          Text('Upcoming Appointments',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...List.generate(
              3,
              (i) => ListTile(
                  leading: const Icon(Icons.event),
                  title: Text('Appointment #$i'),
                  subtitle: const Text('Scheduled'))),
        ]),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
        context: context,
        firstDate: now,
        lastDate: now.add(const Duration(days: 365)),
        initialDate: now);
    if (selected != null) setState(() => _date = selected);
  }

  Future<void> _pickTime() async {
    final selected =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (selected != null) setState(() => _time = selected);
  }
}
