import 'package:event_app/provider/event_provider.dart';
import 'package:event_app/screens/admin/admin_dashboard_screen.dart';
import 'package:event_app/screens/admin/admin_login_screen.dart';
import 'package:event_app/screens/role_selection_screen.dart';
import 'package:event_app/screens/user/event_list_screen.dart';
import 'package:event_app/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ApiService.loadToken();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => EventProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: "/",

      routes: {
        "/": (context) => ApiService.token != null
            ? const EventListScreen()
            : const RoleSelectionScreen(),

        "/login": (context) => AdminLoginScreen(),

        "/adminLogin": (context) => AdminLoginScreen(),

        "/adminDashboard": (context) => const AdminDashboardScreen(),

        "/eventList": (context) => const EventListScreen(),
      },
    );
  }
}
