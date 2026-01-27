import 'package:flutter/material.dart';
import '../services/makeup_api_service.dart';
import './product_detail_screen.dart';
import '../widgets/product_card.dart';
import '../models/product.dart';
import '../data/wishlist_manager.dart';
import 'dart:async';

class WishlistButton extends StatelessWidget {
  final String productId;
  const WishlistButton({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wishlistManager = WishlistManager();
    return AnimatedBuilder(
      animation: wishlistManager,
      builder: (context, _) {
        final isWishlisted = wishlistManager.isInWishlist(productId);
        return IconButton(
          icon: Icon(
            isWishlisted ? Icons.favorite : Icons.favorite_border,
            color: isWishlisted ? Colors.pink : Colors.grey,
            size: 22,
          ),
          onPressed: () async {
            await wishlistManager.toggleWishlist(context, productId);
          },
        );
      },
    );
  }
}

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _makeupApiService = MakeupApiService();
  late Future<List<dynamic>> _futureProducts;
  String _search = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _futureProducts = _makeupApiService.getProductsByBrand('maybelline');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _search = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _refreshProducts();
    });
  }

  void _refreshProducts() {
    setState(() {
      if (_search.trim().isEmpty) {
        _futureProducts = _makeupApiService.getProductsByBrand('maybelline');
      } else {
        _futureProducts = _makeupApiService.getProductsBySearch(_search.trim());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('All Products', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari produk atau brand...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Gagal memuat produk'));
                }
                final productsData = snapshot.data ?? [];
                if (productsData.isEmpty) {
                  return const Center(child: Text('Produk tidak ditemukan.'));
                }
                final products = productsData
                    .where((data) => (data['image_link'] ?? '').toString().trim().isNotEmpty)
                    .map((data) => Product.fromApiJson(data as Map<String, dynamic>))
                    .toList();
                if (products.isEmpty) {
                  return const Center(child: Text('Tidak ada produk bergambar'));
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(product: product),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                                    child: Image.network(
                                      product.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.brand,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        product.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Material(
                              color: Colors.white.withOpacity(0.8),
                              shape: const CircleBorder(),
                              elevation: 2,
                              child: WishlistButton(productId: product.id),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 