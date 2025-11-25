import 'dart:async';
import 'package:flutter/material.dart';
import 'package:leez/constants/colors.dart';
import 'package:leez/screens/user_screens/Request_sent.dart';
import 'package:leez/services/authservice.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> basicProductInfo;
  final bool isFav;

  const ProductDetailScreen({
    Key? key,
    required this.productId,
    required this.basicProductInfo,
    required this.isFav,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  bool isFavorite = false;
  bool isLoading = false;
  bool isBooking = false;

  // Data loading states
  bool isDataLoading = true;
  bool hasError = false;
  String errorMessage = '';

  // Loaded data
  Map<String, dynamic>? productDetails;
  List<Map<String, String>> specifications = [];
  double rating = 2.5;
  List<dynamic> _reviews = [];
  bool _isReviewLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    isFavorite = widget.isFav;
    _loadProductData();
  }

  Future<void> _loadProductData() async {
    try {
      setState(() {
        isDataLoading = true;
        hasError = false;
      });

      final response = await AuthService().itemDetails(widget.productId);
      print("Response: $response");

      final productList = response['productDetails'] as List<dynamic>;
      final productDetailsData = productList[0]['productDetails'];
      final averageRating = productList[0]['averageRating'] ?? 2.5;

      final List<Map<String, String>> specificationsData =
          (response['specifications'] as List)
              .map(
                (item) => {
                  "key": item["key"]?.toString() ?? "",
                  "value": item["value"]?.toString() ?? "",
                },
              )
              .toList();

      setState(() {
        productDetails = productDetailsData;
        specifications = specificationsData;
        rating = averageRating.toDouble();
        isDataLoading = false;
      });

      // Start auto scroll after data is loaded
      _startAutoScroll();

      // Load reviews
      _fetchReviews();
    } catch (e) {
      print("Error loading product data: $e");
      setState(() {
        isDataLoading = false;
        hasError = true;
        errorMessage = 'Failed to load product details';
      });
    }
  }

  void _startAutoScroll() {
    if (productDetails != null && productDetails!['images'] != null) {
      _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
        if (_pageController.hasClients) {
          _currentPage++;
          if (_currentPage >= productDetails!['images'].length) {
            _currentPage = 0;
          }
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void toggleFavorite() async {
    setState(() => isLoading = true);
    try {
      final customerId = '6858ed546ab8ecdbc9264c2e';
      final authService = AuthService();

      if (isFavorite) {
        await authService.removeWishList(
          customerId: customerId,
          productId: widget.productId,
        );
      } else {
        await authService.addWishList(
          customerId: customerId,
          productId: widget.productId,
        );
      }

      setState(() {
        isFavorite = !isFavorite;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to toggle favorite')),
      );
    }
  }

  void _fetchReviews() async {
    final response = await AuthService().feedBackDetails(widget.productId);
    if (response['success'] == true) {
      setState(() {
        _reviews = response['reviews'];
        _isReviewLoading = false;
      });
    } else {
      setState(() => _isReviewLoading = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildLoadingState() {
    final basicProductData =
        widget.basicProductInfo['result'] ?? widget.basicProductInfo;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: null,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Icon(Icons.arrow_back_ios),
          ),
        ),
        title: const Text(
          'Leez',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show basic image while loading
            if (basicProductData['images'] != null &&
                basicProductData['images'].isNotEmpty)
              Container(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  "https://res.cloudinary.com/dyigkc2zy/image/upload/${basicProductData['images'][0]}",
                  fit: BoxFit.contain,
                ),
              )
            else
              Container(
                height: 200,
                color: Colors.grey.shade200,
                child: const Center(
                  child: Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),

            const SizedBox(height: 10),

            // Show basic info while loading
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    basicProductData['name'] ?? 'Loading...',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "₹${basicProductData['price'] ?? '0'}/month",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Loading indicator
            const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Loading product details...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: null,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Icon(Icons.arrow_back_ios),
          ),
        ),
        title: const Text(
          'Leez',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProductData,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isDataLoading) {
      return _buildLoadingState();
    }

    if (hasError) {
      return _buildErrorState();
    }

    final imageUrls = productDetails!['images'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: null,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Icon(Icons.arrow_back_ios),
          ),
        ),
        title: const Text(
          'Leez',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: imageUrls.length,
                    itemBuilder:
                        (context, index) => Image.network(
                          "https://res.cloudinary.com/dyigkc2zy/image/upload/${imageUrls[index]}",
                          fit: BoxFit.contain,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: imageUrls.length,
                    effect: const WormEffect(
                      dotHeight: 6,
                      dotWidth: 6,
                      activeDotColor: Colors.black,
                      dotColor: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Name, Tags, Favorite Icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productDetails!['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "Available",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Rating: $rating",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  isLoading
                      ? const CircularProgressIndicator(strokeWidth: 2)
                      : IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.black54,
                        ),
                        onPressed: toggleFavorite,
                      ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "₹${productDetails!['price']}/month",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            const Divider(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    productDetails!['description'] ?? '',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    specifications.map((spec) {
                      return Container(
                        width: MediaQuery.of(context).size.width / 2 - 24,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              spec['key']!,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                spec['value']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Reviews",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  if (_isReviewLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_reviews.isEmpty)
                    const Text("No reviews found.")
                  else
                    SizedBox(
                      height: 120,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _reviews.length,
                        separatorBuilder:
                            (context, index) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final reviewData = _reviews[index];
                          final customer = reviewData['customer'];
                          final review = reviewData['review'];
                          final photoUrl =
                              "https://res.cloudinary.com/dyigkc2zy/image/upload/${customer['photo']}";
                          return Container(
                            width: 250,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundImage: NetworkImage(photoUrl),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        customer['name'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: List.generate(
                                        review['rating'],
                                        (i) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(review['reviewText'] ?? ''),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Implement contact logic
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Contact Now",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final customerId = '6858ed546ab8ecdbc9264c2e';
                        final price = productDetails!['price'];
                        final count = 1;
                        final startDate = DateTime(2024, 6, 28);
                        final endDate = DateTime(2024, 7, 1);

                        final authService = AuthService();
                        final response = await authService.sendRequests(
                          productId: widget.productId,
                          customerId: customerId,
                          count: count,
                          startDateTime: startDate,
                          endDateTime: endDate,
                          price: price,
                        );

                        if (response['success'] == true) {
                          final imageUrl =
                              "https://res.cloudinary.com/dyigkc2zy/image/upload/${productDetails!['images'][0]}";
                          final productName = productDetails!['name'];
                          final priceStr = productDetails!['price'].toString();
                          final duration =
                              "${endDate.difference(startDate).inDays} days";
                          final dateRange = "June 28 to July 1";

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => RequestSentScreen(
                                    productName: productName,
                                    reqId: "LEEZ1234",
                                    imageUrl: imageUrl,
                                    duration: duration,
                                    dateRange: dateRange,
                                    price: priceStr,
                                  ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                response['message'] ?? 'Booking failed',
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Make Request",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
