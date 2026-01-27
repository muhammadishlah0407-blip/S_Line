import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/makeup_api_service.dart';
import '../models/product.dart';
import 'product_detail_screen.dart';
import 'login_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late Future<List<Product>> _wishlistProductsFuture;

  @override
  void initState() {
    super.initState();
    _wishlistProductsFuture = _loadWishlistProducts();
  }

  Future<List<Product>> _loadWishlistProducts() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return [];
    // 1. Ambil ID produk wishlist user dari Supabase
    final res = await Supabase.instance.client
        .from('wishlist')
        .select('product_id')
        .eq('user_id', user.id);
    final wishlistIds = List<String>.from(res.map((e) => e['product_id']));
    if (wishlistIds.isEmpty) return [];
    // 2. Ambil semua produk dari API (cache), filter hanya yang ada di wishlist
    final allProducts = await MakeupApiService().getProducts();
    final products = allProducts
        .where((p) => wishlistIds.contains((p['id'] ?? '').toString()))
        .map((p) => Product.fromApiJson(p as Map<String, dynamic>))
        .toList();
    return products;
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Favorit', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.pink),
      ),
      body: user == null
          ? Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
                icon: const Icon(Icons.favorite, color: Colors.white),
                label: const Text('Login dulu untuk akses favorit S_Line', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
          : FutureBuilder<List<Product>>(
              future: _wishlistProductsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Gagal memuat favorit'));
                }
                final products = snapshot.data ?? [];
                if (products.isEmpty) {
                  return Center(child: Text('Favorit kamu masih kosong.', style: TextStyle(fontSize: 16)));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: products.length,
                  separatorBuilder: (context, index) => const Divider(height: 24),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(product: product),
                          ),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              product.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text(product.brand, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.pink),
                            tooltip: 'Hapus dari favorit',
                            onPressed: () async {
                              final user = Supabase.instance.client.auth.currentUser;
                              if (user != null) {
                                await Supabase.instance.client
                                    .from('wishlist')
                                    .delete()
                                    .match({'user_id': user.id, 'product_id': product.id});
                                setState(() {
                                  _wishlistProductsFuture = _loadWishlistProducts();
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
} 