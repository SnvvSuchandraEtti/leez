import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditListingScreen extends StatefulWidget {
  final Map<String, dynamic> listing;
  final int index;
  final Function(int, Map<String, dynamic>) onSave;

  const EditListingScreen({Key? key, required this.listing, required this.index, required this.onSave}) : super(key: key);

  @override
  _EditListingScreenState createState() => _EditListingScreenState();
}

class _EditListingScreenState extends State<EditListingScreen> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _typeController;
  late TextEditingController _categoryController;
  late TextEditingController _vehicleSubTypeController;
  late TextEditingController _fuelTypeController;
  late TextEditingController _mileageController;
  late TextEditingController _bikeTypeController;
  late TextEditingController _seatingCapacityController;
  late TextEditingController _carTypeController;
  String? _imagePath;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.listing['name']);
    _priceController = TextEditingController(text: widget.listing['price'].toString());
    _typeController = TextEditingController(text: widget.listing['type']);
    _categoryController = TextEditingController(text: widget.listing['category']);
    _vehicleSubTypeController = TextEditingController(text: widget.listing['vehicleSubType'] ?? '');
    _fuelTypeController = TextEditingController(text: widget.listing['fuelType'] ?? '');
    _mileageController = TextEditingController(text: widget.listing['mileage'] ?? '');
    _bikeTypeController = TextEditingController(text: widget.listing['bikeType'] ?? '');
    _seatingCapacityController = TextEditingController(text: widget.listing['seatingCapacity'] ?? '');
    _carTypeController = TextEditingController(text: widget.listing['carType'] ?? '');
    _imagePath = widget.listing['imagePath'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _typeController.dispose();
    _categoryController.dispose();
    _vehicleSubTypeController.dispose();
    _fuelTypeController.dispose();
    _mileageController.dispose();
    _bikeTypeController.dispose();
    _seatingCapacityController.dispose();
    _carTypeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final updatedListing = {
        'name': _nameController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'type': _typeController.text,
        'category': _categoryController.text,
        'imagePath': _imagePath ?? '',
        'vehicleSubType': _vehicleSubTypeController.text,
        'fuelType': _fuelTypeController.text,
        'mileage': _mileageController.text,
        'bikeType': _bikeTypeController.text,
        'seatingCapacity': _seatingCapacityController.text,
        'carType': _carTypeController.text,
      };

      widget.onSave(widget.index, updatedListing);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Listing updated')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Listing'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _imagePath != null && _imagePath!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(_imagePath!),
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: Icon(Icons.error),
                          ),
                        ),
                      )
                    : Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.image_not_supported),
                      ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter a price' : null,
              ),
              TextFormField(
                controller: _typeController,
                decoration: InputDecoration(labelText: 'Type'),
                validator: (value) => value!.isEmpty ? 'Please enter a type' : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) => value!.isEmpty ? 'Please enter a category' : null,
              ),
              TextFormField(
                controller: _vehicleSubTypeController,
                decoration: InputDecoration(labelText: 'Vehicle SubType (Optional)'),
              ),
              TextFormField(
                controller: _fuelTypeController,
                decoration: InputDecoration(labelText: 'Fuel Type (Optional)'),
              ),
              TextFormField(
                controller: _mileageController,
                decoration: InputDecoration(labelText: 'Mileage (Optional)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _bikeTypeController,
                decoration: InputDecoration(labelText: 'Bike Type (Optional)'),
              ),
              TextFormField(
                controller: _seatingCapacityController,
                decoration: InputDecoration(labelText: 'Seating Capacity (Optional)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _carTypeController,
                decoration: InputDecoration(labelText: 'Car Type (Optional)'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveChanges,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
