import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/dashboard_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://kfgkgicvvlwysbbaerla.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtmZ2tnaWN2dmx3eXNiYmFlcmxhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI4MTI0MTIsImV4cCI6MjA2ODM4ODQxMn0.P1SLBtOWDIiIoIcsc9flrxvVaadn_K6sis8ote9Lids',
  );
  runApp(const SlineApp());
}

class SlineApp extends StatelessWidget {
  const SlineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sline',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
