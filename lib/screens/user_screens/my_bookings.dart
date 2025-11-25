import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:leez/constants/colors.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  List<dynamic> bookings = [];
  bool isLoading = true;
  String errorMessage = '';
  String selectedStatus = 'all';

  final List<String> statusCategories = [
    'all',
    'active',
    'confirmed',
    'returned',
    'cancelled',
  ];

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    const url =
        "https://leez-app.onrender.com/api/bookings/customer-bookings/6858ed546ab8ecdbc9264c2e";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            bookings = data['bookings'];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'No bookings found';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to fetch bookings';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  void onStatusSelect(String status) {
    setState(() {
      selectedStatus = status;
    });
  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('dd MMM, yyyy').format(date);
  }

  Widget buildBookingCard(dynamic booking) {
    final product = booking['product'];
    final imageUrl =
        "https://res.cloudinary.com/dyigkc2zy/image/upload/v1750151597/${product['images'][0]}";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.network(
              imageUrl,
              width: 150,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    color: Colors.grey.shade200,
                    width: 150,
                    height: 100,
                    child: const Icon(
                      Icons.image,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product['description'],
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        size: 14,
                        color: Colors.teal,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${formatDate(booking['startDateTime'])} - ${formatDate(booking['endDateTime'])}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            booking['status'],
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          booking['status'].toUpperCase(),
                          style: TextStyle(
                            color: _getStatusColor(booking['status']),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        '₹${booking['price']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'returned':
        return Colors.green;
      case 'active':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      case 'confirmed':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget buildBookingList() {
    final filteredBookings =
        selectedStatus == 'all'
            ? bookings
            : bookings
                .where((booking) => booking['status'] == selectedStatus)
                .toList();

    if (filteredBookings.isEmpty) {
      return const Center(child: Text("No bookings found for this category."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredBookings.length,
      itemBuilder:
          (context, index) => buildBookingCard(filteredBookings[index]),
    );
  }

  Widget buildStatusCategorySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              statusCategories.map((status) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () => onStatusSelect(status),
                    child: buildCategoryChip(
                      label: status[0].toUpperCase() + status.substring(1),
                      isSelected: selectedStatus == status,
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget buildCategoryChip({required String label, required bool isSelected}) {
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
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,

      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : Column(
                children: [
                  buildStatusCategorySelector(),
                  Expanded(child: buildBookingList()),
                ],
              ),
    );
  }
}
