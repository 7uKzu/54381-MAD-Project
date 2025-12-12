import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:bloodconnect/widgets/organisms/app_shell.dart';
import 'package:bloodconnect/widgets/molecules/stat_card.dart';

class ManagerDashboardPage extends StatelessWidget {
  const ManagerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppShell(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Manager Dashboard', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : 1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: const [
              StatCard(
                  label: 'Inventory Units',
                  value: '320',
                  icon: Icons.inventory_2),
              StatCard(
                  label: 'Completed Donations',
                  value: '82',
                  icon: Icons.volunteer_activism),
              StatCard(
                  label: 'Pending Requests',
                  value: '14',
                  icon: Icons.bloodtype),
            ],
          ),
          const SizedBox(height: 24),
          Text('Weekly Donations', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2)),
              ),
              padding: const EdgeInsets.all(16),
              child: LineChart(LineChartData(
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: const FlTitlesData(show: false),
                lineBarsData: [
                  LineChartBarData(
                      spots: const [
                        FlSpot(0, 5),
                        FlSpot(1, 6),
                        FlSpot(2, 7),
                        FlSpot(3, 10),
                        FlSpot(4, 9),
                        FlSpot(5, 11),
                        FlSpot(6, 12)
                      ],
                      isCurved: true,
                      color: theme.colorScheme.primary,
                      barWidth: 3),
                ],
              )),
            ),
          ),
          const SizedBox(height: 24),
          Text('Recent Activity', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2)),
            ),
            child: ListView.separated(
              itemCount: 6,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => Divider(
                  height: 1,
                  color: theme.colorScheme.outline.withValues(alpha: 0.1)),
              itemBuilder: (_, i) => ListTile(
                leading: const Icon(Icons.history),
                title: Text('Activity #$i'),
                subtitle: const Text('User performed an action...'),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
