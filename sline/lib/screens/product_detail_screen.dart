import 'package:flutter/material.dart';
import '../models/product.dart';
// HAPUS: import '../widgets/review_list.dart';
import '../services/supabase_service.dart';
// HAPUS: import '../models/review.dart';
import '../data/wishlist_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final wishlistManager = WishlistManager();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          AnimatedBuilder(
            animation: wishlistManager,
            builder: (context, _) {
              final isWishlisted = wishlistManager.isInWishlist(widget.product.id);
              return IconButton(
                icon: Icon(
                  isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: isWishlisted ? Colors.pink : null,
                ),
                onPressed: () async {
                  await wishlistManager.toggleWishlist(context, widget.product.id);
                },
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(widget.product.imageUrl, height: 200, fit: BoxFit.cover),
          ),
          const SizedBox(height: 16),
          Text(widget.product.brand, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(widget.product.rating.toString(), style: const TextStyle(fontSize: 16)),
            ],
          ),
          if (widget.product.category != null && widget.product.category!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Chip(label: Text(widget.product.category!)),
            ),
          const SizedBox(height: 16),
          Text(widget.product.description, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          Text('Ingredients:', style: const TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: widget.product.ingredients.map((i) => Chip(label: Text(i))).toList(),
          ),
        ],
      ),
    );
  }
} 