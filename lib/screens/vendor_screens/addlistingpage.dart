import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:leez/constants/colors.dart';
import 'package:path/path.dart';

class AddListingPage extends StatefulWidget {
  @override
  _AddListingPageState createState() => _AddListingPageState();
}

class _AddListingPageState extends State<AddListingPage> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _category = '';
  String _description = '';
  double _price = 0.0;
  File? _image;

  String _specialization = '';
  String _mileage = '';
  String _brakes = '';
  String _bikeType = '';
  String _fuelType = '';
  String _seatingCapacity = '';
  String _carType = '';

  bool _isLoading = false;

  final String email = 'prudvisatyateja123@gmail.com';
  final int count = 1;
  final double latitude = 12.9716;
  final double longitude = 77.5946;

  final List<String> vehicleTypes = ['bike', 'car'];
  final List<String> bikeTypes = [
    'Sports',
    'Cruiser',
    'Standard',
    'Touring',
    'Off-road',
  ];
  final List<String> fuelTypes = ['Petrol', 'Diesel', 'Electric', 'Hybrid'];
  final List<String> carTypes = ['Manual', 'Automatic'];

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    labelStyle: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[800]),
    filled: true,
    fillColor: Colors.grey[100],
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Colors.red, width: 2),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  );

  void pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  Future<void> saveListing() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      final uri = Uri.parse(
        "https://t314vz6b-5001.inc1.devtunnels.ms/api/products/add-product",
      );
      final request = http.MultipartRequest('POST', uri);

      request.fields['email'] = email;
      request.fields['name'] = _name;
      request.fields['category'] = _category;
      request.fields['price'] = _price.toString();
      request.fields['description'] = _description;
      request.fields['count'] = count.toString();
      request.fields['latitude'] = latitude.toString();
      request.fields['longitude'] = longitude.toString();

      final specs = [
        {'key': 'Fuel Type', 'value': _fuelType},
        {'key': 'Mileage', 'value': _mileage},
        {'key': 'Breaks Type', 'value': _brakes},
        {'key': 'Bike Type', 'value': _bikeType},
        {'key': 'Gear Type', 'value': _carType},
        {'key': 'Seating Capacity', 'value': _seatingCapacity},
      ];

      int index = 0;
      for (var spec in specs) {
        if (spec['value']!.isNotEmpty) {
          request.fields['specifications[$index].key'] = spec['key']!;
          request.fields['specifications[$index].value'] = spec['value']!;
          index++;
        }
      }

      if (_image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'images',
            _image!.path,
            filename: basename(_image!.path),
          ),
        );
      }

      final response = await request.send();

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        _formKey.currentState!.reset();
        setState(() {
          _category = '';
          _image = null;
          _specialization = '';
          _mileage = '';
          _brakes = '';
          _bikeType = '';
          _fuelType = '';
          _seatingCapacity = '';
          _carType = '';
        });
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(
            content: Text('Product has been added successfully.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Widget buildFormField(
    String label,
    Function(String?) onSave, {
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: _inputDecoration(label),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        onSaved: onSave,
        validator: validator,
      ),
    );
  }

  Widget buildDropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged, {
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: _inputDecoration(label),
        value: value?.isNotEmpty == true ? value : null,
        items:
            items
                .map((item) => DropdownMenuItem(child: Text(item), value: item))
                .toList(),
        onChanged: onChanged,
        validator: validator,
        icon: Icon(Icons.arrow_drop_down, color: Colors.black54),
        dropdownColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Add Listing',
          style: TextStyle(color: AppColors.secondary),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildFormField(
                'Name',
                (val) => _name = val!,
                validator: (val) => val!.isEmpty ? 'Enter name' : null,
              ),
              buildDropdown(
                'Category',
                _category,
                vehicleTypes,
                (val) => setState(() => _category = val!),
                validator: (val) => val == null ? 'Select category' : null,
              ),
              buildFormField(
                'Description',
                (val) => _description = val!,
                validator: (val) => val!.isEmpty ? 'Enter description' : null,
                maxLines: 3,
              ),
              buildFormField(
                'Specialization (Extra Details)',
                (val) => _specialization = val ?? '',
                maxLines: 2,
              ),

              if (_category == 'bike') ...[
                buildDropdown(
                  'Fuel Type',
                  _fuelType,
                  fuelTypes,
                  (val) => setState(() => _fuelType = val!),
                  validator: (val) => val == null ? 'Select fuel type' : null,
                ),
                buildFormField(
                  'Mileage (km/l)',
                  (val) => _mileage = val ?? '',
                  keyboardType: TextInputType.number,
                  validator: (val) => val!.isEmpty ? 'Enter mileage' : null,
                ),
                buildFormField(
                  'Brakes Type',
                  (val) => _brakes = val ?? '',
                  validator: (val) => val!.isEmpty ? 'Enter brakes' : null,
                ),
                buildDropdown(
                  'Bike Type',
                  _bikeType,
                  bikeTypes,
                  (val) => setState(() => _bikeType = val!),
                  validator: (val) => val == null ? 'Select bike type' : null,
                ),
              ],
              if (_category == 'car') ...[
                buildDropdown(
                  'Fuel Type',
                  _fuelType,
                  fuelTypes,
                  (val) => setState(() => _fuelType = val!),
                  validator: (val) => val == null ? 'Select fuel type' : null,
                ),
                buildFormField(
                  'Mileage (km/l)',
                  (val) => _mileage = val ?? '',
                  keyboardType: TextInputType.number,
                  validator: (val) => val!.isEmpty ? 'Enter mileage' : null,
                ),
                buildFormField(
                  'Seating Capacity',
                  (val) => _seatingCapacity = val ?? '',
                  keyboardType: TextInputType.number,
                  validator: (val) => val!.isEmpty ? 'Enter seating' : null,
                ),
                buildDropdown(
                  'Car Type',
                  _carType,
                  carTypes,
                  (val) => setState(() => _carType = val!),
                  validator: (val) => val == null ? 'Select car type' : null,
                ),
              ],

              buildFormField(
                'Price',
                (val) => _price = double.tryParse(val!) ?? 0.0,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator:
                    (val) =>
                        val!.isEmpty
                            ? 'Enter price'
                            : (double.tryParse(val) == null
                                ? 'Enter valid price'
                                : null),
              ),

              SizedBox(height: 10),

              OutlinedButton.icon(
                onPressed: pickImage,
                icon: Icon(Icons.image, color: Colors.black),
                label: Text(
                  'Pick Image',
                  style: TextStyle(color: Colors.black),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.black),
                  minimumSize: Size(double.infinity, 48),
                ),
              ),

              if (_image != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _image!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

              SizedBox(height: 10),

              ElevatedButton(
                onPressed: _isLoading ? null : saveListing,
                child:
                    _isLoading
                        ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Text("Save Listing"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
