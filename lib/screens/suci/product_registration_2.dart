import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product_registration_3.dart';

// Screen 1: Initial Location Screen with Map
class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _addressController = TextEditingController();
  LatLng _currentLocation = LatLng(13.0827, 80.2707); // Chennai coordinates
  String _currentAddress = "";
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Where is your item located?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "This location helps renters find your item and will only be shared after a booking is confirmed.",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentLocation,
                    initialZoom: 13.0,
                    onTap: (tapPosition, point) async {
                      setState(() {
                        _currentLocation = point;
                      });
                      // Get address for the tapped location
                      await _getAddressFromCoordinates(point);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.airbnb_clone',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 40.0,
                          height: 40.0,
                          point: _currentLocation,
                          child: Container(
                            decoration: BoxDecoration(
                              // color: Colors.red,
                              // shape: BoxShape.circle,
                              // border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(Icons.location_on, color: const Color.fromARGB(255, 255, 0, 0), size: 24),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: 'Enter your address',
                        prefixIcon: Icon(Icons.location_on, color: Colors.black54),
                        suffixIcon: _isSearching 
                          ? Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : null,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                      onSubmitted: (value) async {
                        if (value.isNotEmpty) {
                          await _searchAndMoveToAddress(value);
                        }
                      },
                    ),
                  ),
                ),
                // Show current address at the bottom
                if (_currentAddress.isNotEmpty)
                  Positioned(
                    bottom: 100,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Selected Location:',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _currentAddress,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black87,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Back', style: TextStyle(fontSize: 16)),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddressSearchScreen(
                            searchQuery: _currentAddress.isNotEmpty ? _currentAddress : _addressController.text,
                            selectedLocation: _currentLocation,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Next', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Search for address and move map to that location
  Future<void> _searchAndMoveToAddress(String address) async {
    if (address.isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/search?format=json&q=$address&limit=1&countrycodes=in',
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final result = data[0];
          final lat = double.parse(result['lat']);
          final lon = double.parse(result['lon']);
          final newLocation = LatLng(lat, lon);
          
          setState(() {
            _currentLocation = newLocation;
            _currentAddress = result['display_name'];
          });
          
          // Move map to new location
          _mapController.move(newLocation, 15.0);
        }
      }
    } catch (e) {
      print('Error searching address: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching for address')),
      );
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  // Get address from coordinates (reverse geocoding)
  Future<void> _getAddressFromCoordinates(LatLng location) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=${location.latitude}&lon=${location.longitude}&zoom=18&addressdetails=1',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['display_name'] != null) {
          setState(() {
            _currentAddress = data['display_name'];
          });
        }
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Get initial address for default location
    _getAddressFromCoordinates(_currentLocation);
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }
}

// Screen 2: Address Search with Autocomplete
class AddressSearchScreen extends StatefulWidget {
  final String searchQuery;
  final LatLng? selectedLocation;

  AddressSearchScreen({required this.searchQuery, this.selectedLocation});

  @override
  _AddressSearchScreenState createState() => _AddressSearchScreenState();
}

class _AddressSearchScreenState extends State<AddressSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery;
    if (widget.searchQuery.isNotEmpty) {
      _searchAddress(widget.searchQuery);
    }
  }

  Future<void> _searchAddress(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/search?format=json&q=$query&limit=10&countrycodes=in',
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _searchResults = data.map((item) => {
            'display_name': item['display_name'],
            'lat': double.parse(item['lat']),
            'lon': double.parse(item['lon']),
            'type': item['type'] ?? 'location',
          }).toList();
        });
      }
    } catch (e) {
      print('Error searching address: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Confirm your address',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search location',
                  prefixIcon: Icon(Icons.location_on, color: Colors.black54),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: Colors.black54),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchResults.clear();
                      });
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    Future.delayed(Duration(milliseconds: 500), () {
                      if (_searchController.text == value) {
                        _searchAddress(value);
                      }
                    });
                  }
                },
              ),
            ),
          ),
          if (_isLoading)
            Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(color: Colors.pink),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final result = _searchResults[index];
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.location_city, color: Colors.black54),
                  ),
                  title: Text(
                    _getLocationName(result['display_name']),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    result['display_name'],
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddressFormScreen(
                          selectedAddress: result,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.my_location, color: Colors.pink),
                  title: Text(
                    'Use my current location',
                    style: TextStyle(color: Colors.pink, fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    // Use the selected location from previous screen or default
                    final location = widget.selectedLocation ?? LatLng(13.0827, 80.2707);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddressFormScreen(
                          selectedAddress: {
                            'display_name': widget.searchQuery.isNotEmpty ? widget.searchQuery : 'Current Location, Chennai, Tamil Nadu, India',
                            'lat': location.latitude,
                            'lon': location.longitude,
                          },
                        ),
                      ),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Use the address entered',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    final location = widget.selectedLocation ?? LatLng(13.0827, 80.2707);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddressFormScreen(
                          selectedAddress: {
                            'display_name': _searchController.text.isNotEmpty ? _searchController.text : widget.searchQuery,
                            'lat': location.latitude,
                            'lon': location.longitude,
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getLocationName(String fullAddress) {
    final parts = fullAddress.split(',');
    return parts.isNotEmpty ? parts[0].trim() : fullAddress;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Screen 3: Detailed Address Form
class AddressFormScreen extends StatefulWidget {
  final Map<String, dynamic> selectedAddress;

  AddressFormScreen({required this.selectedAddress});

  @override
  _AddressFormScreenState createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  
  bool _showSpecificLocation = true;
  LatLng _selectedLocation = LatLng(13.0827, 80.2707);

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    final address = widget.selectedAddress['display_name'] as String;
    final parts = address.split(',').map((e) => e.trim()).toList();
    
    // Parse address components more intelligently
    _parseAddressComponents(parts);
    
    if (widget.selectedAddress['lat'] != null && widget.selectedAddress['lon'] != null) {
      _selectedLocation = LatLng(
        widget.selectedAddress['lat'],
        widget.selectedAddress['lon'],
      );
    }
  }

  void _parseAddressComponents(List<String> parts) {
    // Default values
    _countryController.text = 'India';
    
    // Try to extract meaningful information from the address parts
    if (parts.isNotEmpty) {
      // First part is usually street/building
      _streetController.text = parts[0];
      
      // Look for state, city, and pin code patterns
      for (String part in parts) {
        // Check for PIN code (6 digits)
        if (RegExp(r'^\d{6}$').hasMatch(part.trim())) {
          _pinController.text = part.trim();
        }
        // Check for common Indian states
        else if (part.toLowerCase().contains('nadu') || 
                 part.toLowerCase().contains('pradesh') ||
                 part.toLowerCase().contains('kerala') ||
                 part.toLowerCase().contains('karnataka') ||
                 part.toLowerCase().contains('maharashtra') ||
                 part.toLowerCase().contains('gujarat') ||
                 part.toLowerCase().contains('rajasthan') ||
                 part.toLowerCase().contains('punjab') ||
                 part.toLowerCase().contains('haryana') ||
                 part.toLowerCase().contains('bihar') ||
                 part.toLowerCase().contains('west bengal') ||
                 part.toLowerCase().contains('odisha') ||
                 part.toLowerCase().contains('jharkhand') ||
                 part.toLowerCase().contains('chhattisgarh') ||
                 part.toLowerCase().contains('uttarakhand') ||
                 part.toLowerCase().contains('himachal pradesh') ||
                 part.toLowerCase().contains('assam') ||
                 part.toLowerCase().contains('meghalaya') ||
                 part.toLowerCase().contains('manipur') ||
                 part.toLowerCase().contains('nagaland') ||
                 part.toLowerCase().contains('mizoram') ||
                 part.toLowerCase().contains('arunachal pradesh') ||
                 part.toLowerCase().contains('sikkim') ||
                 part.toLowerCase().contains('tripura') ||
                 part.toLowerCase().contains('goa') ||
                 part.toLowerCase().contains('delhi')) {
          _stateController.text = part.trim();
        }
      }
      
      // If we have multiple parts, try to guess city and district
      if (parts.length > 2) {
        // Usually city is near the end but before state
        for (int i = parts.length - 1; i >= 0; i--) {
          if (!parts[i].toLowerCase().contains('india') && 
              !RegExp(r'^\d{6}$').hasMatch(parts[i].trim()) &&
              _stateController.text != parts[i].trim() &&
              _cityController.text.isEmpty) {
            _cityController.text = parts[i].trim();
            break;
          }
        }
        
        // District is often before city
        if (parts.length > 3 && _districtController.text.isEmpty) {
          for (int i = 1; i < parts.length - 2; i++) {
            if (parts[i].trim() != _cityController.text &&
                parts[i].trim() != _stateController.text &&
                !RegExp(r'^\d{6}$').hasMatch(parts[i].trim())) {
              _districtController.text = parts[i].trim();
              break;
            }
          }
        }
      }
    }
    
    // Fallback values if parsing didn't work well
    if (_cityController.text.isEmpty) {
      _cityController.text = parts.length > 1 ? parts[1] : '';
    }
    if (_stateController.text.isEmpty) {
      _stateController.text = parts.length > 2 ? parts[parts.length - 2] : '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Confirm your address',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildDropdownField(
                      label: 'Country/region',
                      controller: _countryController,
                      items: ['India', 'United States', 'United Kingdom', 'Canada'],
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      label: 'Flat, house, etc. (if applicable)',
                      hint: 'Street address',
                      controller: _streetController,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      label: 'Nearby landmark (if applicable)',
                      controller: _landmarkController,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      label: 'District/locality (if applicable)',
                      controller: _districtController,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      label: 'City / town',
                      controller: _cityController,
                      required: true,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      label: 'State/province/territory',
                      controller: _stateController,
                      required: true,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      label: 'PIN code',
                      controller: _pinController,
                      keyboardType: TextInputType.number,
                      required: true,
                    ),
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Show your specific location',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'This location helps renters find your item and will only be shared after a booking is confirmed.',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Learn more',
                                        style: TextStyle(
                                          color: Colors.pink,
                                          fontSize: 12,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: _showSpecificLocation,
                                onChanged: (value) {
                                  setState(() {
                                    _showSpecificLocation = value;
                                  });
                                },
                                activeColor: Colors.pink,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: _selectedLocation,
                            initialZoom: 15.0,
                            interactionOptions: const InteractionOptions(
                              flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                            ),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.airbnb_clone',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  width: 40.0,
                                  height: 40.0,
                                  point: _selectedLocation,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.pink,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: Icon(Icons.home, color: Colors.white, size: 20),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "We'll share your approximate location",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Navigate to AddPhotos screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddPhotos(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Looks good',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint ?? label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.pink, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: required
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required TextEditingController controller,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: controller.text.isNotEmpty ? controller.text : null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.pink, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              controller.text = newValue;
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _countryController.dispose();
    _streetController.dispose();
    _landmarkController.dispose();
    _districtController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinController.dispose();
    super.dispose();
  }
}