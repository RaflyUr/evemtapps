import 'package:flutter/material.dart';
import 'package:event_manager/screens/login_screen.dart';
import 'package:event_manager/screens/register_screen.dart';
import 'package:event_manager/screens/event_list_screen.dart';
import 'package:event_manager/screens/create_event_screen.dart';
import 'package:event_manager/utils/session_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Manager',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      // Tentukan layar awal berdasarkan status login
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthChecker(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/events': (context) => const EventListScreen(),
        '/create-event': (context) => const CreateEventScreen(),
      },
    );
  }
}

// Widget ini memeriksa apakah pengguna sudah login atau belum di inisiasi
class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    String? token = await SessionManager.getToken();
    if (token != null) {
      // Jika ada token, arahkan ke daftar event
      Navigator.of(context).pushReplacementNamed('/events');
    } else {
      // Jika tidak ada token, arahkan ke login
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tampilkan loading indicator selagi memeriksa
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}