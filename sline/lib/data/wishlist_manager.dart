import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

class WishlistManager extends ChangeNotifier {
  static final WishlistManager _instance = WishlistManager._internal();
  factory WishlistManager() => _instance;
  WishlistManager._internal();

  final List<String> _wishlistIds = [];

  List<String> get wishlistIds => _wishlistIds;

  bool isInWishlist(String productId) => _wishlistIds.contains(productId);

  Future<void> toggleWishlist(BuildContext context, String productId) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      // Tampilkan dialog login
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Login Diperlukan'),
          content: const Text('Silakan login untuk menggunakan wishlist.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Tutup'),
            ),
          ],
        ),
      );
      return;
    }
    if (_wishlistIds.contains(productId)) {
      await SupabaseService().removeFromWishlist(userId: user.id, productId: productId);
      _wishlistIds.remove(productId);
    } else {
      await SupabaseService().addToWishlist(userId: user.id, productId: productId);
      _wishlistIds.add(productId);
    }
    notifyListeners();
  }

  Future<void> syncWishlistFromServer(String userId) async {
    _wishlistIds.clear();
    final ids = await SupabaseService().getWishlistProductIds(userId);
    _wishlistIds.addAll(ids);
    notifyListeners();
  }

  Future<void> addToWishlist(String userId, String productId) async {
    await SupabaseService().addToWishlist(userId: userId, productId: productId);
    _wishlistIds.add(productId);
    notifyListeners();
  }

  Future<void> removeFromWishlist(String userId, String productId) async {
    await SupabaseService().removeFromWishlist(userId: userId, productId: productId);
    _wishlistIds.remove(productId);
    notifyListeners();
  }
} 