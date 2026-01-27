import 'package:flutter/material.dart';
import '../widgets/navigation_bar.dart';
import 'home_screen.dart';
import 'product_screen.dart';
import 'collections_screen.dart';
import 'wishlist_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  List<Widget> _pages = <Widget>[
    HomeScreen(),
    ProductScreen(),
    CollectionsScreen(),
    WishlistScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      body: _pages[_selectedIndex],
      bottomNavigationBar: SlineNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.black),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/images/kosmetik.png'),
                ),
                const SizedBox(height: 12),
                const Text('Sign in / Sign up', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
          ),
          _buildDrawerItem(Icons.fiber_new, 'NEW'),
          _buildDrawerItem(Icons.grid_view, 'All Products'),
          _buildDrawerItem(Icons.branding_watermark, 'All Brands'),
          _buildDrawerItem(Icons.star, 'Bestsellers'),
          _buildDrawerItem(Icons.article, 'Blogs'),
          _buildDrawerItem(Icons.reviews, 'Review of the Month'),
          _buildDrawerItem(Icons.quiz, 'KS Quiz'),
          _buildDrawerItem(Icons.info, 'About us'),
          _buildDrawerItem(Icons.support, 'Support'),
          _buildDrawerItem(Icons.language, 'Language Switcher'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.pink),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      onTap: () {},
    );
  }
} 