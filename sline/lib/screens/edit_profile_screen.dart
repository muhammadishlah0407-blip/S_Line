import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String _email = '-';
  bool _loading = true;
  bool _avatarUploading = false;
  File? _selectedImage;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final supabase = Supabase.instance.client;
      final profile = await supabase
          .from('profiles')
          .select('display_name, email, avatar_url')
          .eq('id', user.id)
          .maybeSingle();
      _nameController.text = profile?['display_name'] ?? '';
      _email = profile?['email'] ?? '-';
      _avatarUrl = profile?['avatar_url'];
    }
    setState(() { _loading = false; });
  }

  Future<void> _pickAndUploadImage() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    setState(() => _avatarUploading = true);
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked == null) {
      setState(() => _avatarUploading = false);
      return;
    }
    final fileExt = picked.name.split('.').last;
    final filePath = '${user.id}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';
    final storage = Supabase.instance.client.storage;
    try {
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        await storage.from('avatars').uploadBinary(
          filePath,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );
      } else {
        final file = File(picked.path);
        await storage.from('avatars').upload(
          filePath,
          file,
          fileOptions: const FileOptions(upsert: true),
        );
      }
      final publicUrl = storage.from('avatars').getPublicUrl(filePath);
      await Supabase.instance.client
          .from('profiles')
          .update({'avatar_url': publicUrl})
          .eq('id', user.id);
      if (mounted) {
        setState(() {
          _avatarUrl = publicUrl;
          _selectedImage = !kIsWeb ? File(picked.path) : null;
          _avatarUploading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _avatarUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal upload avatar: $e')),
      );
    }
  }

  Future<void> _saveProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        await Supabase.instance.client.from('profiles').update({
          'display_name': _nameController.text,
          'avatar_url': _avatarUrl,
        }).eq('id', user.id);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal update profil: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Edit Profil', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.pink),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundColor: Colors.pink[50],
                              backgroundImage: _avatarUrl != null && _avatarUrl!.isNotEmpty ? NetworkImage(_avatarUrl!) : null,
                              child: _avatarUrl == null || _avatarUrl!.isEmpty
                                  ? const Icon(Icons.person, size: 48, color: Colors.pink)
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _avatarUploading ? null : _pickAndUploadImage,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: _avatarUploading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.pink),
                                        )
                                      : const Icon(Icons.edit, size: 20, color: Colors.pink),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nama Lengkap',
                          labelStyle: const TextStyle(color: Colors.pink),
                          filled: true,
                          fillColor: Colors.pink[50],
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                        ),
                        style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                        validator: (value) => value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        initialValue: _email,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.pink),
                          filled: true,
                          fillColor: Colors.pink[50],
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                        ),
                        style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading
                              ? null
                              : () async {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    setState(() => _loading = true);
                                    await _saveProfile();
                                    setState(() => _loading = false);
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Profil berhasil disimpan!')),
                                      );
                                      Navigator.pop(context, {
                                        'name': _nameController.text,
                                        'email': _email,
                                        'avatar_url': _avatarUrl ?? '',
                                      });
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          child: _loading
                              ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('Simpan Perubahan'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
} 