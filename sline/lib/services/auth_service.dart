import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../screens/login_screen.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<void> login(String email, String password, BuildContext context) async {
    try {
      final res = await supabase.auth.signInWithPassword(email: email, password: password);
      if (res.user != null && context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
          (route) => false,
        );
      }
    } on AuthException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(e.message)),
      );
    }
  }

  Future<void> register(String email, String password, String name, BuildContext context) async {
    try {
      final res = await supabase.auth.signUp(email: email, password: password, data: {'display_name': name});
      if (res.user != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Registrasi berhasil! Silakan login.'),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } on AuthException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(e.message)),
      );
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await supabase.auth.signOut();
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {}
  }

  Future<void> updateProfile({required String userId, String? displayName, String? avatarUrl, String? bio}) async {
    final updates = <String, dynamic>{};
    if (displayName != null) updates['display_name'] = displayName;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
    if (bio != null) updates['bio'] = bio;
    if (updates.isEmpty) return;
    await supabase.from('profiles').update(updates).eq('id', userId);
  }
} 