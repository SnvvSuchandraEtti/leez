import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'product_registration_1.dart';

class LeezOnboardingScreen extends StatelessWidget {
  const LeezOnboardingScreen({super.key});

  void _showRentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const RentSelectionBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showRentBottomSheet(context),
          child: const Text('Rent Something'),
        ),
      ),
    );
  }
}

class RentSelectionBottomSheet extends StatefulWidget {
  const RentSelectionBottomSheet({super.key});

  @override
  State<RentSelectionBottomSheet> createState() => _RentSelectionBottomSheetState();
}

class _RentSelectionBottomSheetState extends State<RentSelectionBottomSheet> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 30.w,
                height: 4.h,
                margin: EdgeInsets.only(top: 12.h, bottom: 7.h),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 30.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 8.h),
              
              // Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'What would you like to Rent?',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              
              SizedBox(height: 16.h),
              
              // Options
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    _buildOptionCard(
                      title: 'Vehicle',
                      icon: '🚗',
                      value: 'Vehicle',
                      isSelected: selectedOption == 'Vehicle',
                    ),
                    
                    SizedBox(height: 8.h),
                    
                    _buildOptionCard(
                      title: 'Electronics & Gadgets',
                      icon: '📸',
                      value: 'Electronics & Gadgets',
                      isSelected: selectedOption == 'Electronics & Gadgets',
                    ),

                    SizedBox(height: 8.h),

                    _buildOptionCard(
                      title: 'Furniture & Appliances',
                      icon: '🛋️',
                      value: 'Furniture & Appliances',
                      isSelected: selectedOption == 'Furniture & Appliances',
                    ),
                    
                    SizedBox(height: 8.h),
                    
                    _buildOptionCard(
                      title: 'Spaces & Venues',
                      icon: '🏠',
                      value: 'Spaces & Venues',
                      isSelected: selectedOption == 'Spaces & Venues',
                    ),
                    
                    SizedBox(height: 8.h),
                    
                    _buildOptionCard(
                      title: 'Others',
                      icon: '📦',
                      value: 'Others',
                      isSelected: selectedOption == 'Others',
                    ),
                    
                    SizedBox(height: 20.h),
                    
                    // Next button
SizedBox(
  width: double.infinity,
  height: 48.h,
  child: ElevatedButton(
    onPressed: selectedOption != null
        ? () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LeezOnboardingScreen1()),
            );
          }
        : null,
    style: ElevatedButton.styleFrom(
      backgroundColor: selectedOption != null ? Colors.black : Colors.grey[300],
      foregroundColor: selectedOption != null ? Colors.white : Colors.grey[600],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
    ),
    child: Text(
      'Next',
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
),

                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String icon,
    required String value,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = value;
        });
      },
      child: Container(
        width: double.infinity,
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[100] : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  icon,
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}