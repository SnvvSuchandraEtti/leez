import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leez/constants/colors.dart';
import 'package:leez/screens/user_screens/Profile.dart';
import 'package:leez/screens/user_screens/my_bookings.dart';
import 'package:leez/screens/user_screens/productCard.dart';
import 'package:leez/services/authservice.dart';
import 'wishlist_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  Set<String> favoriteProductIds = {};

  void onItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  String selectedCategory = 'Cars';

  void onCategoryTap(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  Widget buildHomeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fixed header section
        buildSearchBar(),
        const SizedBox(height: 8),
        buildCategorySelector(),

        // Scrollable content section
        Expanded(
          child:
              selectedCategory == 'All'
                  ? buildAllBody()
                  : selectedCategory == 'Cars'
                  ? buildCarsBody()
                  : buildBikesBody(),
        ),
      ],
    );
  }

  Widget getCurrentScreen() {
    switch (selectedIndex) {
      case 0:
        return buildHomeContent();
      case 1:
        return BookingsScreen();
      case 2:
        return const WishlistScreen();

      case 3:
        return ProfilePage();

      default:
        return const Center(child: Text("Page not found"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 16,
        automaticallyImplyLeading: false,
        title: const Text(
          'leez',
          style: TextStyle(
            fontFamily: 'pacifico',
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.black),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.location_on, color: AppColors.secondary),
            ),
          ),
        ],
      ),
      body: getCurrentScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,

        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[500],

        selectedFontSize: 12,
        unselectedFontSize: 11,

        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          letterSpacing: -0.1,
        ),

        showSelectedLabels: true,
        showUnselectedLabels: true,

        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Icon(Icons.home_outlined, size: 26),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Icon(Icons.home_rounded, size: 28),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Icon(Icons.book_outlined, size: 26),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Icon(Icons.book, size: 28),
            ),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Icon(Icons.favorite_border, size: 26),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Icon(Icons.favorite, size: 28),
            ),
            label: 'Wishlist',
          ),

          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Icon(Icons.person_outline, size: 26),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Icon(Icons.person, size: 28),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 10),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Find right leez',
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.tune, color: Colors.grey),
              onPressed: () {
                // Filter logic
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLocationSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.location_on, size: 20, color: Colors.black87),
            SizedBox(width: 8),
            Text(
              'New York, USA',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.black87),
          ],
        ),
      ),
    );
  }

  Widget buildCategorySelector() {
    final categories = ['All', 'Cars', 'Bikes'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children:
            categories.map((category) {
              IconData icon;

              if (category == 'All') {
                icon = Icons.layers;
              } else if (category == 'Cars') {
                icon = Icons.directions_car;
              } else {
                icon = Icons.two_wheeler;
              }

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => onCategoryTap(category),
                  child: buildCategoryChip(
                    icon: icon,
                    label: category,
                    isSelected: selectedCategory == category,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget buildCategoryChip({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          if (!isSelected)
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.black),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAllBody() {
    return FutureBuilder<Map<String, dynamic>>(
      future: AuthService().fetchAllPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData && snapshot.data!['success'] == true) {
          final products = snapshot.data!['products'] as List<dynamic>;
          return buildProductsGrid(products);
        } else {
          return const Center(child: Text("No products found."));
        }
      },
    );
  }

  Widget buildCarsBody() {
    return FutureBuilder<Map<String, dynamic>>(
      future: AuthService().fetchPosts('car'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData && snapshot.data!['success'] == true) {
          final products = snapshot.data!['products'] as List<dynamic>;
          print(products);
          return buildProductsGrid(products);
        } else {
          return const Center(child: Text("No products found."));
        }
      },
    );
  }

  Widget buildBikesBody() {
    return FutureBuilder<Map<String, dynamic>>(
      future: AuthService().fetchPosts('bike'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData && snapshot.data!['success'] == true) {
          final products = snapshot.data!['products'] as List<dynamic>;
          return buildProductsGrid(products);
        } else {
          return const Center(child: Text("No products found."));
        }
      },
    );
  }

  Widget buildProductsGrid(List<dynamic> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(product: product);
      },
    );
  }
}
