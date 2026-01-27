import 'package:flutter/material.dart';

class ProductDetailFromApiScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductDetailFromApiScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ingredients = (product['ingredients'] as List?)?.cast<String>() ?? [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(product['name'] ?? '', style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              product['image_link'] ?? 'https://via.placeholder.com/300',
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 100),
            ),
          ),
          const SizedBox(height: 16),
          Text(product['brand'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          Text(product['name'] ?? '', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          if (product['description'] != null && product['description'].toString().isNotEmpty)
            Text(product['description'], style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 16),
          if (ingredients.isNotEmpty) ...[
            const Text('Ingredients:', style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: ingredients.map((i) => Chip(label: Text(i))).toList(),
            ),
          ],
        ],
      ),
    );
  }
} 