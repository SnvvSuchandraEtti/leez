import 'package:flutter/material.dart';
import 'package:leez/constants/colors.dart';
import 'package:leez/screens/vendor_screens/requests_for_vendorDashBoard.dart';
import 'package:leez/screens/vendor_screens/saleschart.dart';
import 'package:leez/screens/vendor_screens/vendor_active_rentals.dart';

import 'kyc_IdentityVerificationScreen1.dart';

// not calling this from main dash board calling the dashboardscreen down ok

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leez/constants/colors.dart';
import 'package:leez/screens/vendor_screens/requests_for_vendorDashBoard.dart';
import 'package:leez/screens/vendor_screens/saleschart.dart';
import 'package:leez/screens/vendor_screens/vendor_active_rentals.dart';
import 'kyc_IdentityVerificationScreen1.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String myRentals = '...';
  String requests = '...';
  String monthlyRevenue = '...';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      final resRentals = await http.get(
        Uri.parse(
          'https://leez-app.onrender.com/api/bookings/rentals-count/684fb005ef0c1addb3ee47f3',
        ),
      );
      final resRequests = await http.get(
        Uri.parse(
          'https://leez-app.onrender.com/api/bookings/requests-count/684fb005ef0c1addb3ee47f3',
        ),
      );
      final resRevenue = await http.get(
        Uri.parse(
          'https://leez-app.onrender.com/api/bookings/total-revenue/684fb005ef0c1addb3ee47f3',
        ),
      );

      if (resRentals.statusCode == 200 &&
          resRequests.statusCode == 200 &&
          resRevenue.statusCode == 200) {
        final rentalsJson = json.decode(resRentals.body);
        final requestsJson = json.decode(resRequests.body);
        final revenueJson = json.decode(resRevenue.body);

        setState(() {
          myRentals = rentalsJson['count'][0]['count'].toString();
          requests = requestsJson['count'][0]['requests'].toString();
          monthlyRevenue =
              "₹${revenueJson['totalRevenue'][0]['totalRevenue'].toString()}";
          isLoading = false;
        });
      } else {
        throw Exception("Failed to fetch one or more APIs");
      }
    } catch (e) {
      print("API error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<DashboardCardData> cards = [
      DashboardCardData(
        icon: Icons.view_list,
        count: myRentals,
        label: 'My Rentals',
        color: AppColors.primary,
        hoverColor: Colors.lightBlue.shade200,
      ),
      DashboardCardData(
        icon: Icons.calendar_today,
        count: requests,
        label: 'Requests',
        color: AppColors.primary,
        hoverColor: Colors.green.shade200,
      ),
      DashboardCardData(
        icon: Icons.calendar_today_sharp,
        count: monthlyRevenue,
        label: 'Monthly Revenue',
        color: AppColors.primary,
        hoverColor: Colors.purple.shade200,
      ),
    ];

    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10),
        child: ScrollConfiguration(
          behavior: ScrollBehavior().copyWith(scrollbars: false),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Row(
                  children: [
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Welcome back,",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Balaraju",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Stack(
                        children: const [
                          Positioned(
                            right: 6,
                            bottom: 9,
                            child: Icon(Icons.notifications_none, size: 29),
                          ),
                          Positioned(
                            top: 5,
                            right: 12,
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children:
                      cards.asMap().entries.map((entry) {
                        int index = entry.key;
                        DashboardCardData card = entry.value;
                        double cardWidth =
                            (card.label == "Monthly Revenue") ? 340 : 160;

                        return GestureDetector(
                          onTap: () {
                            switch (index) {
                              case 0:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => vendor_active_rentals(),
                                  ),
                                );
                                break;
                              case 1:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RentalRequestsScreen(),
                                  ),
                                );
                                break;
                            }
                          },
                          child: DashboardCard(card, customWidth: cardWidth),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 40),
                SalesChart(),
                const SizedBox(height: 30),
                KYCStatusCard(kycVerified: false),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class KYCStatusCard extends StatelessWidget {
  final bool kycVerified;

  const KYCStatusCard({required this.kycVerified});

  @override
  Widget build(BuildContext context) {
    // Only show the card if KYC is NOT verified
    if (kycVerified) return SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(58, 0, 0, 0),
            blurRadius: 8,
            offset: Offset(2, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text(
                "KYC Verification Pending",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Complete your verification to unlock premium features and higher earning potential.",
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IdentityVerificationScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Complete KYC Now",
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardCardData {
  final IconData icon;
  final String count;
  final String label;
  final Color color;
  final Color hoverColor;

  DashboardCardData({
    required this.icon,
    required this.count,
    required this.label,
    required this.color,
    required this.hoverColor,
  });
}

class DashboardCard extends StatefulWidget {
  final DashboardCardData data;
  final double? customWidth;

  DashboardCard(this.data, {this.customWidth});

  @override
  _DashboardCardState createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          width: widget.customWidth ?? 160,
          height: 150,
          decoration: BoxDecoration(
            color: isHovered ? widget.data.hoverColor : widget.data.color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(58, 0, 0, 0),
                blurRadius: 8,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(widget.data.icon, size: 28),
              const SizedBox(height: 20),
              Text(
                widget.data.count,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(widget.data.label),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingStatusWidget extends StatelessWidget {
  final String bookingStatus;

  BookingStatusWidget({required this.bookingStatus});

  final List<String> steps = [
    "Requested",
    "Approved",
    "Picked Up",
    "Returned",
    "Completed",
  ];

  @override
  Widget build(BuildContext context) {
    int activeSteps = bookingStatus == "completed" ? 5 : 3;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF7FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                "Current Booking",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(width: 6),
              Icon(Icons.circle, color: Colors.green, size: 10),
            ],
          ),
          const SizedBox(height: 20),
          ...List.generate(steps.length, (index) {
            bool isActive = index < activeSteps;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  isActive
                      ? CircleAvatar(
                        backgroundColor: Colors.purpleAccent,
                        radius: 12,
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      )
                      : CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        radius: 12,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  const SizedBox(width: 12),
                  Text(
                    steps[index],
                    style: TextStyle(
                      fontSize: 16,
                      color: isActive ? Colors.black : Colors.grey,
                      fontWeight:
                          isActive ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    isActive ? Icons.circle : Icons.circle_outlined,
                    color: isActive ? Colors.green : Colors.grey,
                    size: 10,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
