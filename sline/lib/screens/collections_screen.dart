import 'package:flutter/material.dart';
import '../services/makeup_api_service.dart';
import 'product_list_by_brand_screen.dart';

class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({Key? key}) : super(key: key);

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  late Future<List<String>> _futureBrands;
  @override
  void initState() {
    super.initState();
    _futureBrands = MakeupApiService().getBrands();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Collections', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.favorite_border, color: Colors.pink), onPressed: () {}),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: _futureBrands,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Gagal memuat kategori/brand'));
          }
          final brands = snapshot.data ?? [];
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'What are you looking for?',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                  onTap: () {},
                  readOnly: true,
                ),
              ),
              ...brands.map((brand) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.pink[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.local_offer, color: Colors.pink),
                  ),
                  title: Text(brand, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductListByBrandScreen(brand: brand),
                      ),
                    );
                  },
                ),
              )),
            ],
          );
        },
      ),
    );
  }
} 