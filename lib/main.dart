import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/health_data_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/profile_details_screen.dart';
import 'screens/splash_screen.dart';
import 'services/local_storage_service.dart'; // مهم عشان تـ initialize التخزين

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init(); // ✅ نعمل init قبل التشغيل

  runApp(const DiabetesApp());
}

class DiabetesApp extends StatelessWidget {
  const DiabetesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diabetes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/health_data': (context) => const HealthDataScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/profile_details': (context) => const ProfileDetailsScreen(),
      },
    );
  }
}
