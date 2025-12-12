import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:bloodconnect/providers/auth_provider.dart';
import 'package:bloodconnect/pages/home_page.dart';
import 'package:bloodconnect/pages/auth/login_page.dart';
import 'package:bloodconnect/pages/auth/register_page.dart';
import 'package:bloodconnect/features/pages.dart';

/// GoRouter configuration for app navigation
///
/// This uses go_router for declarative routing, which provides:
/// - Type-safe navigation
/// - Deep linking support (web URLs, app links)
/// - Easy route parameters
/// - Navigation guards and redirects
///
/// To add a new route:
/// 1. Add a route constant to AppRoutes below
/// 2. Add a GoRoute to the routes list
/// 3. Navigate using context.go() or context.push()
/// 4. Use context.pop() to go back.
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      // Role-aware redirect for dashboards
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final loggedIn = auth.isLoggedIn;
      final loc = state.uri.toString();
      if (!loggedIn && _isProtected(loc)) return AppRoutes.login;
      if (loggedIn && (loc == AppRoutes.login || loc == AppRoutes.register)) {
        final role = auth.user!.role.name;
        return _dashboardForRole(role);
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: HomePage()),
      ),
      GoRoute(
          path: AppRoutes.login,
          name: 'login',
          pageBuilder: (c, s) => const NoTransitionPage(child: LoginPage())),
      GoRoute(
          path: AppRoutes.register,
          name: 'register',
          pageBuilder: (c, s) => const NoTransitionPage(child: RegisterPage())),
      GoRoute(
          path: AppRoutes.manager,
          name: 'manager',
          pageBuilder: (c, s) =>
              const NoTransitionPage(child: ManagerDashboardPage())),
      GoRoute(
          path: AppRoutes.recipient,
          name: 'recipient',
          pageBuilder: (c, s) =>
              const NoTransitionPage(child: RecipientDashboardPage())),
      GoRoute(
          path: AppRoutes.donor,
          name: 'donor',
          pageBuilder: (c, s) =>
              const NoTransitionPage(child: DonorDashboardPage())),
      GoRoute(
          path: AppRoutes.staff,
          name: 'staff',
          pageBuilder: (c, s) =>
              const NoTransitionPage(child: StaffDashboardPage())),
      GoRoute(
          path: AppRoutes.technician,
          name: 'technician',
          pageBuilder: (c, s) =>
              const NoTransitionPage(child: TechnicianDashboardPage())),
      GoRoute(
          path: AppRoutes.admin,
          name: 'admin',
          pageBuilder: (c, s) =>
              const NoTransitionPage(child: AdminDashboardPage())),
      GoRoute(
          path: AppRoutes.medical,
          name: 'medical',
          pageBuilder: (c, s) =>
              const NoTransitionPage(child: MedicalDashboardPage())),
    ],
  );

  static bool _isProtected(String loc) => loc.startsWith('/dashboard');
  static String _dashboardForRole(String role) {
    switch (role) {
      case 'BloodBankManager':
        return AppRoutes.manager;
      case 'Recipient':
        return AppRoutes.recipient;
      case 'Donor':
        return AppRoutes.donor;
      case 'Staff':
        return AppRoutes.staff;
      case 'Technician':
        return AppRoutes.technician;
      case 'Admin':
        return AppRoutes.admin;
      case 'MedicalStaff':
        return AppRoutes.medical;
      default:
        return AppRoutes.home;
    }
  }
}

/// Route path constants
/// Use these instead of hard-coding route strings
class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String manager = '/dashboard/manager';
  static const String recipient = '/dashboard/recipient';
  static const String donor = '/dashboard/donor';
  static const String staff = '/dashboard/staff';
  static const String technician = '/dashboard/technician';
  static const String admin = '/dashboard/admin';
  static const String medical = '/dashboard/medical';
}
