import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import for Google Maps

class vendor_spacearrival extends StatefulWidget {
  const vendor_spacearrival({super.key});

  @override
  State<vendor_spacearrival> createState() => _homeState();
}

class _homeState extends State<vendor_spacearrival> {
  int selectedIndex = 0; // 0 = Your space, 1 = Arrival guide

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          "Listing editor",
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.settings, color: Colors.black),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background as in the image
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTab("Your space", 0),
                _buildTab("Arrival guide", 1),
              ],
            ),
          ),
          Expanded(
            child: selectedIndex == 0 ? _buildYourSpaceContent() : _buildArrivalGuideContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    bool isSelected = selectedIndex == index;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0), // Increased spacing between tabs
        child: GestureDetector(
          onTap: () => setState(() => selectedIndex = index),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(30), // Fully rounded corners for each tab
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
                  : [],
            ),
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, {String? subtitle, IconData? icon, Widget? customContent, bool showChevron = true}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: customContent ??
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.black54, size: 24),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      if (subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: title == "Complete required steps"
                                  ? Colors.black87
                                  : Colors.black54,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (showChevron)
                  const Icon(Icons.chevron_right, color: Colors.black54),
              ],
            ),
      ),
    );
  }

  Widget _buildYourSpaceContent() {
    return ListView(
      children: [
        _buildCard(
          "Complete required steps",
          subtitle: "Finish these final tasks to publish your listing and start getting booked.",
          customContent: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Complete required steps",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Finish these final tasks to publish your listing and start getting booked.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black54),
            ],
          ),
        ),
        _buildCard(
          "Photo tour",
          subtitle: "1 bedroom · 1 bed · 1 bath",
          customContent: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Photo tour",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              // Network image for Photo tour
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "1 bedroom · 1 bed · 1 bath",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
          showChevron: false,
        ),
        _buildCard("Title", subtitle: "fake"),
        _buildCard("Property type", subtitle: "Entire place · Rental unit"),
        _buildCard(
          "Pricing",
          subtitle: "₹1,794 per night\n10% weekly discount",
        ),
        _buildCard(
          "Availability",
          subtitle: "1–365 night stays\nSame-day advance notice",
        ),
        _buildCard("Number of guests", subtitle: "4 guests"),
        _buildCard(
          "Description",
          subtitle: "You'll have a great time at this comfortable place to stay.",
        ),
        _buildCard("Amenities"),
        _buildCard("Accessibility features"),
        _buildCard(
          "Location",
          subtitle: "Mandapeta By-pass Rd, Gandhi Nagar, Mandapeta, Andhra Pradesh 533308, India",
          customContent: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Location",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              // Google Map widget for Location
              SizedBox(
                height: 150,
                width: double.infinity,
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(16.8675, 81.9326), // Coordinates for Mandapeta
                    zoom: 14,
                  ),
                  markers: {
                    const Marker(
                      markerId: MarkerId('location'),
                      position: LatLng(16.8675, 81.9326),
                      infoWindow: InfoWindow(title: "Mandapeta"),
                    ),
                  },
                  liteModeEnabled: true, // Use lite mode for better performance
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Mandapeta By-pass Rd, Gandhi Nagar, Mandapeta, Andhra Pradesh 533308, India",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
          showChevron: false,
        ),
        _buildCard(
          "About the host",
          subtitle: "Suchandra\nStarted hosting in 2025",
          customContent: Row(
            children: [
              // Network image for host profile
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "About the host",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Suchandra\nStarted hosting in 2025",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
          showChevron: false,
        ),
        _buildCard("Co-hosts"),
        _buildCard("Booking settings", subtitle: "Guests can book automatically with Instant Book"),
        _buildCard(
          "House Rules",
          subtitle: "4 guests maximum",
          icon: Icons.people,
        ),
        _buildCard(
          "Guest safety",
          subtitle: "Carbon monoxide alarm not reported\nSmoke alarm not reported",
          customContent: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Guest safety",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.cancel_outlined, color: Colors.black54, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Carbon monoxide alarm not reported",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.cancel_outlined, color: Colors.black54, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Smoke alarm not reported",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
          showChevron: false,
        ),
        _buildCard("Cancellation policy", subtitle: "Flexible"),
        _buildCard("Custom link"),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.remove_red_eye, size: 20),
            label: const Text("View"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArrivalGuideContent() {
    return ListView(
      children: [
        _buildCard(
          "Complete required steps",
          subtitle: "Finish these final tasks to publish your listing",
          customContent: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Complete required steps",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Finish these final tasks to publish your listing and start getting booked.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black54),
            ],
          ),
        ),
        _buildCard("Check-in"),
        _buildCard("Checkout"),
        _buildCard("Directions"),
        _buildCard("Check-in method"),
        _buildCard("Wi-Fi details"),
        _buildCard("House manual"),
        _buildCard(
          "House Rules",
          subtitle: "4 guests maximum",
          icon: Icons.people,
        ),
        _buildCard("Checkout instructions"),
        _buildCard("Guidebooks"),
        _buildCard("Interaction preferences"),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.remove_red_eye, size: 20),
            label: const Text("View"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ),
      ],
    );
  }
}
