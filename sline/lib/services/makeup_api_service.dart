import 'dart:convert';
import 'package:http/http.dart' as http;

class MakeupApiService {
  static const String baseUrl = 'https://makeup-api.herokuapp.com/api/v1';

  List<dynamic>? _cachedProducts;
  Map<String, List<dynamic>> _brandCache = {};
  Map<String, List<dynamic>> _typeCache = {};

  Future<List<dynamic>> getProducts() async {
    if (_cachedProducts != null) return _cachedProducts!;
    final response = await http.get(Uri.parse('$baseUrl/products.json'));
    if (response.statusCode == 200) {
      _cachedProducts = json.decode(response.body) as List;
      return _cachedProducts!;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<dynamic>> getProductsByBrand(String brand) async {
    if (_brandCache.containsKey(brand)) return _brandCache[brand]!;
    final response = await http.get(Uri.parse('$baseUrl/products.json?brand=$brand'));
    if (response.statusCode == 200) {
      final products = (json.decode(response.body) as List).take(10).toList();
      _brandCache[brand] = products;
      return products;
    } else {
      throw Exception('Failed to load products by brand');
    }
  }

  Future<List<dynamic>> getProductsByType(String type) async {
    if (_typeCache.containsKey(type)) return _typeCache[type]!;
    final response = await http.get(Uri.parse('$baseUrl/products.json?product_type=$type'));
    if (response.statusCode == 200) {
      final products = (json.decode(response.body) as List).take(10).toList();
      _typeCache[type] = products;
      return products;
    } else {
      throw Exception('Failed to load products by type');
    }
  }

  Future<List<String>> getBrands() async {
    final products = await getProducts();
    final brands = products.map((p) => p['brand'] as String?).where((b) => b != null && b.isNotEmpty).toSet().toList();
    brands.sort();
    return brands.cast<String>();
  }

  Future<List<dynamic>> getProductsBySearch(String search) async {
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