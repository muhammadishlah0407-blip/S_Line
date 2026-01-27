import 'package:flutter/material.dart';
import '../services/makeup_api_service.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import '../models/product.dart';
import '../data/wishlist_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _makeupApiService = MakeupApiService();
  late Future<List<dynamic>> _futureProducts;
  String? _selectedBrand = 'maybelline';
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _futureProducts = _makeupApiService.getProductsByBrand('maybelline');
  }

  void _filterProducts() {
    if (_selectedBrand != null && _selectedBrand!.isNotEmpty) {
      _futureProducts = _makeupApiService.getProductsByBrand(_selectedBrand!);
    } else if (_selectedType != null && _selectedType!.isNotEmpty) {
      _futureProducts = _makeupApiService.getProductsByType(_selectedType!);
    } else {
      _futureProducts = _makeupApiService.getProducts();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            SizedBox(
              height: 36,
              child: Image.asset(
                'assets/images/logo kosmetik 2.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Text('Sline', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Sline', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.favorite_border, color: Colors.pink), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedBrand,
                    decoration: InputDecoration(
                      labelText: 'Brand',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      filled: true,
                      fillColor: Colors.pink[50],
                    ),
                    items: ['maybelline', 'loreal', 'covergirl', 'revlon', 'nyx', 'milani', 'e.l.f.'].map((brand) {
                      return DropdownMenuItem(
                        value: brand,
                        child: Text(brand),
                      );
                    }).toList(),
                    onChanged: (val) {
                      _selectedBrand = val;
                      _selectedType = null;
                      _filterProducts();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: InputDecoration(
                      labelText: 'Tipe',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      filled: true,
                      fillColor: Colors.purple[50],
                    ),
                    items: [null, 'lipstick', 'foundation', 'blush', 'eyeliner', 'mascara', 'nail_polish'].map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type == null ? 'Semua Tipe' : type),
                      );
                    }).toList(),
                    onChanged: (val) {
                      _selectedType = val;
                      _selectedBrand = null;
                      _filterProducts();
                    },
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
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.pink[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                      );
                    },
                  );
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Gagal memuat produk'));
                }
                final productsData = snapshot.data ?? [];
                if (productsData.isEmpty) {
                  return const Center(child: Text('Tidak ada produk'));
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
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.65,
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
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.pink.withOpacity(0.07),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(color: Colors.pink[50]!, width: 2),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                    child: Image.network(
                                      product.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: Colors.pink[50],
                                        child: const Icon(Icons.image, color: Colors.pink),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.pink),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        product.brand,
                                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        product.price != null ? '\$${product.price}' : '-',
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),
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