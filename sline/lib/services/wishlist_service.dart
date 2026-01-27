import 'package:supabase_flutter/supabase_flutter.dart';

class WishlistService {
  final supabase = Supabase.instance.client;

  Future<void> addToWishlist(String productId) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    await supabase.from('wishlist').insert({
      'user_id': user.id,
      'product_id': productId,
    });
  }

  Future<void> removeFromWishlist(String productId) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    await supabase.from('wishlist').delete().match({
      'user_id': user.id,
      'product_id': productId,
    });
  }

  Future<List<String>> getWishlistProductIds() async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    final res = await supabase
        .from('wishlist')
        .select('product_id')
        .eq('user_id', user.id);
    return List<String>.from(res.map((e) => e['product_id']));
  }
} 