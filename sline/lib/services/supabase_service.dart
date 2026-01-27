import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';
import '../models/ingredient.dart';

class SupabaseService {
  final _client = Supabase.instance.client;

  Future<List<Product>> getProducts({String? search, String? category, String? ingredient}) async {
    final query = _client.from('products').select();
    // Filter pencarian
    if (search != null && search.isNotEmpty) {
      query.ilike('name', '%$search%');
    }
    if (category != null && category.isNotEmpty) {
      query.eq('category', category);
    }
    // Untuk filter ingredients, perlu query custom
    final data = await query;
    List<Product> products = (data as List).map((e) => Product.fromJson(e)).toList();
    if (ingredient != null && ingredient.isNotEmpty) {
      products = products.where((p) => p.ingredients.contains(ingredient)).toList();
    }
    return products;
  }

  Future<List<String>> getWishlistProductIds(String userId) async {
    final res = await _client
        .from('wishlist')
        .select('product_id')
        .eq('user_id', userId);
    return List<String>.from(res.map((e) => e['product_id']));
  }

  Future<void> addToWishlist({required String userId, required String productId}) async {
    await _client.from('wishlist').insert({
      'user_id': userId,
      'product_id': productId,
    });
  }

  Future<void> removeFromWishlist({required String userId, required String productId}) async {
    await _client.from('wishlist').delete().match({
      'user_id': userId,
      'product_id': productId,
    });
  }

  Future<List<Ingredient>> getIngredients() async {
    final data = await _client.from('ingredients').select();
    return (data as List).map((e) => Ingredient.fromJson(e)).toList();
  }

  Future<void> updateProfile({required String userId, required String name, required String email, String? avatarUrl}) async {
    await _client.from('users').update({
      'name': name,
      'email': email,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    }).eq('id', userId);
  }
} 