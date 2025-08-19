import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String selectedCategory = 'All';

  final List<String> categories = ['All', 'Appetizers', 'Main Course', 'Desserts', 'Beverages'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        selectedCategory = categories[_tabController.index];
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.white,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFCC3333), Color(0xFFFF6B6B)],
                  ),
                ),
                child: FlexibleSpaceBar(
                  title: const Text(
                    'Our Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  centerTitle: false,
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                  background: Stack(
                    children: [
                      Positioned(
                        right: -50,
                        top: -50,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        bottom: 60,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
          body: Column(
            children: [
              // Category Tabs
              Container(
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: const Color(0xFFCC3333),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: const Color(0xFFCC3333),
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                  tabs: categories.map((category) => Tab(text: category)).toList(),
                ),
              ),
              
              // Menu Items
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: categories.map((category) => _buildMenuCategory(category)).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      // Floating Action Button for Cart
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFCC3333), Color(0xFFFF6B6B)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFCC3333).withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.shopping_cart, color: Colors.white),
          label: const Text(
            'Cart (0)',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCategory(String category) {
    List<Map<String, dynamic>> items = _getItemsForCategory(category);
    
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildEnhancedMenuItem(
          item['title'],
          item['price'],
          item['description'],
          item['imagePath'],
          item['rating'],
          item['isPopular'],
          item['isVegetarian'],
        );
      },
    );
  }

  Widget _buildEnhancedMenuItem(
    String title,
    String price,
    String description,
    String imagePath,
    double rating,
    bool isPopular,
    bool isVegetarian,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image Section
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset(
                  imagePath,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Text(
                          'Image not found',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Badges
              Positioned(
                top: 12,
                left: 12,
                child: Row(
                  children: [
                    if (isPopular) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCC3333),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Popular',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (isVegetarian)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF27AE60),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Veg',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Rating
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Content Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          price,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFCC3333),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFCC3333), Color(0xFFFF6B6B)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFCC3333).withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.add, color: Colors.white, size: 18),
                            label: const Text(
                              'Add to Cart',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getItemsForCategory(String category) {
    final allItems = [
      // Appetizers
      {
        'title': 'Crispy Chicken Wings',
        'price': 'Rs.180',
        'description': 'Spicy buffalo wings with blue cheese dip and celery sticks',
        'imagePath': 'assets/wings.webp',
        'rating': 4.5,
        'isPopular': true,
        'isVegetarian': false,
        'category': 'Appetizers',
      },
      {
        'title': 'Mozzarella Sticks',
        'price': 'Rs.120',
        'description': 'Golden fried mozzarella with marinara sauce',
        'imagePath': 'assets/mozzarella.jpg',
        'rating': 4.2,
        'isPopular': false,
        'isVegetarian': true,
        'category': 'Appetizers',
      },
      
      // Main Course
      {
        'title': 'Grilled Salmon',
        'price': 'Rs.450',
        'description': 'Fresh Atlantic salmon with herbs and lemon butter sauce',
        'imagePath': 'assets/salmon.jpg',
        'rating': 4.8,
        'isPopular': true,
        'isVegetarian': false,
        'category': 'Main Course',
      },
      {
        'title': 'Pasta Primavera',
        'price': 'Rs.280',
        'description': 'Fresh vegetables tossed in creamy alfredo sauce with penne pasta',
        'imagePath': 'assets/pasta.jpg',
        'rating': 4.3,
        'isPopular': false,
        'isVegetarian': true,
        'category': 'Main Course',
      },
      {
        'title': 'Chicken Tikka Masala',
        'price': 'Rs.320',
        'description': 'Tender chicken in rich tomato and cream curry sauce',
        'imagePath': 'assets/tikka.webp',
        'rating': 4.7,
        'isPopular': true,
        'isVegetarian': false,
        'category': 'Main Course',
      },
      
      // Desserts
      {
        'title': 'Chocolate Lava Cake',
        'price': 'Rs.150',
        'description': 'Warm chocolate cake with molten center, served with vanilla ice cream',
        'imagePath': 'assets/cake.webp',
        'rating': 4.6,
        'isPopular': true,
        'isVegetarian': true,
        'category': 'Desserts',
      },
      {
        'title': 'Tiramisu',
        'price': 'Rs.180',
        'description': 'Classic Italian dessert with coffee-soaked ladyfingers',
        'imagePath': 'assets/tiramisu.webp',
        'rating': 4.4,
        'isPopular': false,
        'isVegetarian': true,
        'category': 'Desserts',
      },
      
      // Beverages
      {
        'title': 'Fresh Mango Smoothie',
        'price': 'Rs.80',
        'description': 'Creamy mango smoothie with yogurt and honey',
        'imagePath': 'assets/mango_smoothie.jpg',
        'rating': 4.2,
        'isPopular': false,
        'isVegetarian': true,
        'category': 'Beverages',
      },
      {
        'title': 'Masala Chai',
        'price': 'Rs.40',
        'description': 'Traditional Indian spiced tea with milk and aromatic spices',
        'imagePath': 'assets/chai.jpg',
        'rating': 4.5,
        'isPopular': true,
        'isVegetarian': true,
        'category': 'Beverages',
      },
    ];

    if (category == 'All') {
      return allItems;
    }
    return allItems.where((item) => item['category'] == category).toList();
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Appetizers':
        return const Color(0xFFE74C3C);
      case 'Main Course':
        return const Color(0xFFCC3333);
      case 'Desserts':
        return const Color(0xFF9B59B6);
      case 'Beverages':
        return const Color(0xFF3498DB);
      default:
        return const Color(0xFFCC3333);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Appetizers':
        return Icons.restaurant;
      case 'Main Course':
        return Icons.lunch_dining;
      case 'Desserts':
        return Icons.cake;
      case 'Beverages':
        return Icons.local_drink;
      default:
        return Icons.restaurant_menu;
    }
  }
}