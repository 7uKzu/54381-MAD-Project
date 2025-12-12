import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:bloodconnect/providers/auth_provider.dart';
import 'package:bloodconnect/widgets/organisms/app_shell.dart';
import 'package:bloodconnect/widgets/molecules/stat_card.dart';
import 'package:bloodconnect/widgets/common/role_card.dart';
import 'package:bloodconnect/nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _slide = Tween(begin: const Offset(0, .06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ac, curve: Curves.easeOut));
    _ac.forward();
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return AppShell(
      child: LayoutBuilder(builder: (context, c) {
        final isWide = c.maxWidth > 800;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (!auth.isLoggedIn) ...[
              SlideTransition(
                position: _slide,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Donate blood. Save lives.',
                            style: Theme.of(context).textTheme.headlineLarge),
                        const SizedBox(height: 8),
                        Text(
                            'BloodConnect links donors to recipients and powers blood bank operations with real-time alerts.',
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 16),
                        Wrap(spacing: 12, children: [
                          FilledButton(
                              onPressed: () => context.go(AppRoutes.login),
                              child: const Text('Login')),
                          OutlinedButton(
                              onPressed: () => context.go(AppRoutes.register),
                              child: const Text('Register')),
                        ]),
                      ]),
                ),
              ),
              const SizedBox(height: 24),
            ],
            Text('Quick access', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: isWide ? 7 : 2,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: const [
                RoleCard(
                    label: 'Donor',
                    icon: Icons.favorite,
                    route: AppRoutes.donor),
                RoleCard(
                    label: 'Recipient',
                    icon: Icons.person_search,
                    route: AppRoutes.recipient),
                RoleCard(
                    label: 'Manager',
                    icon: Icons.dashboard,
                    route: AppRoutes.manager),
                RoleCard(
                    label: 'Technician',
                    icon: Icons.science,
                    route: AppRoutes.technician),
                RoleCard(
                    label: 'Staff', icon: Icons.event, route: AppRoutes.staff),
                RoleCard(
                    label: 'Admin',
                    icon: Icons.admin_panel_settings,
                    route: AppRoutes.admin),
                RoleCard(
                    label: 'Medical',
                    icon: Icons.local_hospital,
                    route: AppRoutes.medical),
              ],
            ),
            const SizedBox(height: 24),
            Text('Overview', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: isWide ? 3 : 1,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: const [
                StatCard(
                    label: 'Open Requests', value: '12', icon: Icons.bloodtype),
                StatCard(
                    label: 'Inventory Units',
                    value: '320',
                    icon: Icons.inventory_2),
                StatCard(
                    label: 'Active Alerts', value: '3', icon: Icons.warning),
              ],
            ),
          ]),
        );
      }),
    );
  }
}
