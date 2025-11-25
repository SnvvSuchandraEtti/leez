import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leez/constants/colors.dart';
import 'package:leez/screens/vendor_screens/view_details_in_my_rentals.dart';

class Rental {
  final String title;
  final String image;
  final String date;
  final String status;
  final String rentedBy;

  Rental({
    required this.title,
    required this.image,
    required this.date,
    required this.status,
    required this.rentedBy,
  });

  factory Rental.fromJson(Map<String, dynamic> json) {
    final product = json['product'];
    final booking = json['bookings'];
    final customer = json['name'] ?? "Unknown";

    final startDate = booking['startDateTime'].substring(0, 10);
    final endDate = booking['endDateTime'].substring(0, 10);

    return Rental(
      title: product['name'] ?? '',
      image:
          'https://res.cloudinary.com/dyigkc2zy/image/upload/v1750151597/${product['images'][0]}',
      date: '$startDate - $endDate',
      status: booking['status'],
      rentedBy: customer,
    );
  }
}

class vendor_active_rentals extends StatefulWidget {
  const vendor_active_rentals({super.key});

  @override
  State<vendor_active_rentals> createState() => _vendorActiveRentalsState();
}

class _vendorActiveRentalsState extends State<vendor_active_rentals>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final String vendorId = "684fb005ef0c1addb3ee47f3";

  List<Rental> activeRentals = [];
  List<Rental> completedRentals = [];
  List<Rental> upcomingRentals = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchAllRentals();
  }

  Future<void> fetchAllRentals() async {
    setState(() => isLoading = true);
    try {
      final activeUrl =
          'https://leez-app.onrender.com/api/bookings/active-rentals/$vendorId';
      final completedUrl =
          'https://leez-app.onrender.com/api/bookings/completed-rentals/$vendorId';
      final upcomingUrl =
          'https://leez-app.onrender.com/api/bookings/confirmed-rentals/$vendorId';

      final responses = await Future.wait([
        http.get(Uri.parse(activeUrl)),
        http.get(Uri.parse(completedUrl)),
        http.get(Uri.parse(upcomingUrl)),
      ]);

      if (responses.every((res) => res.statusCode == 200)) {
        final activeJson = json.decode(responses[0].body)['bookings'];
        final completedJson = json.decode(responses[1].body)['bookings'];
        final upcomingJson = json.decode(responses[2].body)['bookings'];

        setState(() {
          activeRentals = List<Rental>.from(
            activeJson.map((item) => Rental.fromJson(item)),
          );
          completedRentals = List<Rental>.from(
            completedJson.map((item) => Rental.fromJson(item)),
          );
          upcomingRentals = List<Rental>.from(
            upcomingJson.map((item) => Rental.fromJson(item)),
          );
          isLoading = false;
        });
      } else {
        throw Exception("One or more requests failed.");
      }
    } catch (e) {
      print("Error fetching rentals: $e");
      setState(() => isLoading = false);
    }
  }

  Widget buildRentalCard(Rental rental) {
    return Card(
      color: AppColors.primary,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                rental.image,

                height: 70,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 70,
                    height: 70,
                    color: AppColors.primary,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    rental.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(rental.date, style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          rental.status == 'active'
                              ? Colors.green
                              : rental.status == 'upcoming'
                              ? Colors.blue
                              : Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      rental.status[0].toUpperCase() +
                          rental.status.substring(1),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ReturnConfirmationScreen(
                                  title: rental.title,
                                  imageUrl: rental.image,
                                  rentedBy: rental.rentedBy,
                                  returnDueDate: rental.date.split(' - ')[1],
                                ),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Text(
                          'View Details',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRentalList(List<Rental> rentals) {
    if (rentals.isEmpty) {
      return const Center(child: Text("No rentals available"));
    }
    return ListView.builder(
      itemCount: rentals.length,
      itemBuilder: (context, index) => buildRentalCard(rentals[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text("My Rentals", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          indicatorColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "Active"),
            Tab(text: "Completed"),
            Tab(text: "Upcoming"),
          ],
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                controller: _tabController,
                children: [
                  buildRentalList(activeRentals),
                  buildRentalList(completedRentals),
                  buildRentalList(upcomingRentals),
                ],
              ),
    );
  }
}
