import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/schedules_screen.dart';
import 'screens/crew_management_screen.dart';
import 'screens/reports_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyABfKwbaGP8q21zY09esOULhGaQ14D6kq0",
          appId: "1:367962602401:web:878df25367c0660b7629e0",
          messagingSenderId: "367962602401",
          projectId: "transit-flow"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TransitFlow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Define routes for navigation
      initialRoute: '/',
      routes: {
        '/': (context) => DashboardScreen(),
        '/schedules': (context) => ScheduleScreen(),
        '/crew-management': (context) => CrewManagementScreen(),
        '/reports': (context) => ReportsScreen(),
      },
    );
  }
}
