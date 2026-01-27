import '../models/product.dart';

final List<Product> dummyProducts = [
  Product(
    id: 'p1',
    name: 'Cosrx Low pH Good Morning Gel Cleanser',
    brand: 'Cosrx',
    imageUrl: 'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2',
    rating: 4.7,
    ingredients: ['Water', 'Betaine Salicylate', 'Tea Tree Oil'],
    description: 'Pembersih wajah dengan pH rendah, cocok untuk kulit sensitif dan berminyak.',
  ),
  Product(
    id: 'p2',
    name: 'Some By Mi AHA BHA PHA 30 Days Miracle Toner',
    brand: 'Some By Mi',
    imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
    rating: 4.5,
    ingredients: ['AHA', 'BHA', 'PHA', 'Niacinamide'],
    description: 'Toner eksfoliasi ringan untuk mencerahkan dan membersihkan pori.',
  ),
  Product(
    id: 'p3',
    name: 'Laneige Water Sleeping Mask',
    brand: 'Laneige',
    imageUrl: 'https://images.unsplash.com/photo-1464983953574-0892a716854b',
    rating: 4.8,
    ingredients: ['Water', 'Glycerin', 'Beta-Glucan'],
    description: 'Masker malam untuk melembapkan dan menyegarkan kulit saat tidur.',
  ),
]; 