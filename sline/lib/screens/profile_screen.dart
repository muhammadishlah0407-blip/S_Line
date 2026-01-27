import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, String?>> _profileFuture;
  late Future<Map<String, int>> _statsFuture;

  @override
  void initState() {
    super.initState();
    _refreshProfile();
  }

  void _refreshProfile() {
    _profileFuture = getUserProfile();
    _statsFuture = getUserStats();
    setState(() {});
  }

  Future<Map<String, String?>> getUserProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return {'name': '-', 'email': '-', 'avatar_url': ''};
    }
    final supabase = Supabase.instance.client;
    final profile = await supabase
        .from('profiles')
        .select('display_name, email, avatar_url')
        .eq('id', user.id)
        .maybeSingle();
    return {
      'name': profile?['display_name'] ?? '-',
      'email': profile?['email'] ?? '-',
      'avatar_url': profile?['avatar_url'] ?? '',
    };
  }

  Future<Map<String, int>> getUserStats() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return {'wishlist': 0, 'review': 0};
    }
    final supabase = Supabase.instance.client;
    final wishlist = await supabase
        .from('wishlist')
        .select('id')
        .eq('user_id', user.id);
    final reviews = await supabase
        .from('reviews')
        .select('id')
        .eq('user_id', user.id);
    return {
      'wishlist': wishlist.length,
      'review': reviews.length,
    };
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Account', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.pink),
            onPressed: _refreshProfile,
            tooltip: 'Refresh Profil',
          ),
        ],
      ),
      body: user == null
          ? Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
                icon: const Icon(Icons.lock_open, color: Colors.white),
                label: const Text('Masuk ke Akun S_Line', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE1BEE7),
                  foregroundColor: Colors.pink,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  elevation: 2,
                ),
              ),
            )
          : FutureBuilder<Map<String, String?>> (
              future: _profileFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Gagal memuat profil'));
                }
                final data = snapshot.data ?? {};
                final displayName = (data['name'] ?? '').trim().isEmpty ? 'Nama belum diatur' : data['name']!;
                final avatarUrl = data['avatar_url'] ?? '';
                final email = (data['email'] ?? '').trim().isEmpty ? 'Email belum diatur' : data['email']!;
                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(height: 32),
                    Center(
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.pink[50],
                        backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                        child: avatarUrl.isEmpty ? const Icon(Icons.person, size: 48, color: Colors.pink) : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        displayName,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.pink),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        email,
                        style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: FutureBuilder<Map<String, int>>(
                        future: _statsFuture,
                        builder: (context, statSnapshot) {
                          final stats = statSnapshot.data ?? {'wishlist': 0, 'review': 0};
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F4FC),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatColumn(
                                  icon: Icons.reviews,
                                  iconBg: Colors.pink[100]!,
                                  iconColor: Colors.pink,
                                  count: stats['review']?.toString() ?? '0',
                                  label: 'Review',
                                ),
                                _buildStatColumn(
                                  icon: Icons.favorite,
                                  iconBg: Colors.pink[100]!,
                                  iconColor: Colors.pinkAccent,
                                  count: stats['wishlist']?.toString() ?? '0',
                                  label: 'Favorit',
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                                );
                                if (result != null) {
                                  _refreshProfile();
                                }
                              },
                              icon: const Icon(Icons.edit, color: Colors.white),
                              label: const Text('Edit Profil'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                elevation: 2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                await Supabase.instance.client.auth.signOut();
                                if (context.mounted) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                                    (route) => false,
                                  );
                                }
                              },
                              icon: const Icon(Icons.logout, color: Colors.pink),
                              label: const Text('Logout'),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.pink, width: 2),
                                foregroundColor: Colors.pink,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildStatColumn({required IconData icon, required Color iconBg, required Color iconColor, required String count, required String label}) {
    return Expanded(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 10),
          Text(count, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.pink)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 15)),
        ],
      ),
    );
  }
} 