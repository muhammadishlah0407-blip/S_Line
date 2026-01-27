import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class LocalProductService {
  static List<dynamic>? _cachedProducts;

  static Future<List<dynamic>> getProducts() async {
    if (_cachedProducts != null) return _cachedProducts!;
    try {
      final String response = await rootBundle.loadString('assets/products.json');
      _cachedProducts = json.decode(response) as List;
      return _cachedProducts!;
    } catch (e) {
      // Jika file rusak atau tidak bisa dibaca, return list kosong
      return [];
    }
  }

  static Future<List<dynamic>> getProductsByBrand(String brand) async {
    final products = await getProducts();
    return products.where((p) => (p['brand'] ?? '').toLowerCase() == brand.toLowerCase()).take(10).toList();
  }

  static Future<List<dynamic>> getProductsByType(String type) async {
    final products = await getProducts();
    return products.where((p) => (p['product_type'] ?? '').toLowerCase() == type.toLowerCase()).take(10).toList();
  }

  static Future<List<String>> getBrands() async {
    final products = await getProducts();
    final brands = products.map((p) => p['brand'] as String?).where((b) => b != null && b.isNotEmpty).toSet().toList();
    brands.sort();
    return brands.cast<String>();
  }

  static Future<List<dynamic>> getProductsBySearch(String search) async {
    final products = await getProducts();
    final query = search.toLowerCase();
    return products.where((p) {
      final name = (p['name'] ?? '').toString().toLowerCase();
      final brand = (p['brand'] ?? '').toString().toLowerCase();
      final desc = (p['description'] ?? '').toString().toLowerCase();
      return name.contains(query) || brand.contains(query) || desc.contains(query);
    }).toList();
  }
} 