import 'package:flutter/material.dart';
import 'package:leez/screens/user_screens/product_details.dart';
import 'package:leez/services/authservice.dart';

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.product.containsKey('status');
  }

  void toggleFavorite() async {
    setState(() {
      isLoading = true;
    });

    try {
      final productId =
          widget.product['result']?['_id'] ?? widget.product['_id'];
      final customerId = '6858ed546ab8ecdbc9264c2e';
      final authService = AuthService();

      if (isFavorite) {
        await authService.removeWishList(
          customerId: customerId,
          productId: productId,
        );
      } else {
        await authService.addWishList(
          customerId: customerId,
          productId: productId,
        );
      }

      setState(() {
        isFavorite = !isFavorite;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to toggle favorite')));
    }
  }

  void navigateToDetail() {
    final productMap = widget.product;
    final productId = productMap['result']?['_id'];
    
    if (productId == null) {
      print("Error: product ID is null");
      print("productMap: $productMap");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid product')));
      return;
    }

    // Navigate immediately with productId and basic product info
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(
          productId: productId,
          basicProductInfo: productMap,
          isFav: isFavorite,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productData = widget.product['result'] ?? widget.product;
    final imageUrl =
        "https://res.cloudinary.com/dyigkc2zy/image/upload/${productData['images'][0]}";

    return GestureDetector(
      onTap: navigateToDetail,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : GestureDetector(
                          onTap: toggleFavorite,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.white,
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.black,
                              size: 16,
                            ),
                          ),
                        ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                productData['name'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                productData['description'] ?? '',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "₹${productData['price']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.amber),
                      SizedBox(width: 2),
                      Text(
                        '${productData['averageRating'] == null ? 2.5 : productData['averageRating']}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}