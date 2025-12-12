import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'nav.dart';
import 'package:bloodconnect/services/auth_service.dart';
import 'package:bloodconnect/providers/auth_provider.dart';
import 'package:bloodconnect/core/network/socket_service.dart';
import 'package:bloodconnect/providers/alerts_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final authProvider = AuthProvider(AuthService());
  final alertsProvider = AlertsProvider(SocketService());

  @override
  void initState() {
    super.initState();
    authProvider.init().then((_) => alertsProvider.init());
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: alertsProvider),
      ],
      child: MaterialApp.router(
        title: 'BloodConnect',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
