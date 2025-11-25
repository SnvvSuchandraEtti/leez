import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Shared Components
class ProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  
  const ProgressIndicator({Key? key, required this.currentStep, required this.totalSteps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        return Container(
          width: 40,
          height: 4,
          margin: EdgeInsets.only(right: index < totalSteps - 1 ? 4 : 0),
          decoration: BoxDecoration(
            color: index < currentStep ? Colors.black : Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}

// Updated NextButton class with full width
class NextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  
  const NextButton({Key? key, required this.onPressed, this.text = 'Next'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Full width button
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16), // Slightly more padding for better look
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

// Updated AppScaffold class - removed progress bar
class AppScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final int currentStep;
  final VoidCallback? onNext;
  final VoidCallback? onBack; // Keep parameter for compatibility but won't show button
  final String nextText;
  
  const AppScaffold({
    Key? key,
    required this.title,
    this.subtitle,
    required this.child,
    required this.currentStep,
    this.onNext,
    this.onBack,
    this.nextText = 'Next',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            if (subtitle != null) ...[
              SizedBox(height: 8),
              Text(subtitle!, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            ],
            SizedBox(height: 32),
            Expanded(child: child),
            // Progress bar removed from here
            SizedBox(height: 24),
            if (onNext != null)
              NextButton(onPressed: onNext!, text: nextText),
          ],
        ),
      ),
    );
  }
}
// Screen 1: Booking Settings
class BookingSettingsScreen extends StatefulWidget {
  @override
  _BookingSettingsScreenState createState() => _BookingSettingsScreenState();
}

class _BookingSettingsScreenState extends State<BookingSettingsScreen> {
  int selectedOption = 0;

  Widget _buildOption(int value, String title, String description, {String? icon}) {
    return GestureDetector(
      onTap: () => setState(() => selectedOption = value),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: selectedOption == value ? Colors.black : Colors.grey[300]!,
            width: selectedOption == value ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Radio<int>(
              value: value,
              groupValue: selectedOption,
              onChanged: (v) => setState(() => selectedOption = v!),
              activeColor: Colors.black,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      if (icon != null) ...[SizedBox(width: 8), Text(icon, style: TextStyle(fontSize: 16))],
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(description, style: TextStyle(fontSize: 15, color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Pick your booking settings',
      subtitle: 'You can change this at any time.',
      currentStep: 1,
      onNext: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GuestSelectionScreen())),
      child: Column(
        children: [
          _buildOption(
            0,
            'Approve your bookings',
            'Review each rental request before accepting, you can switch to Instant Rent so users can book automatically.',
          ),
          _buildOption(
            1,
            'Use Instant Rent',
            'Let users book automatically.',
            icon: '⚡',
          ),
        ],
      ),
    );
  }
}

// Screen 2: Guest Selection
class GuestSelectionScreen extends StatefulWidget {
  @override
  _GuestSelectionScreenState createState() => _GuestSelectionScreenState();
}

class _GuestSelectionScreenState extends State<GuestSelectionScreen> {
  String selectedGuestType = 'any';

  Widget _buildGuestOption(String value, String title, String description, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: selectedGuestType == value ? Colors.black : Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: selectedGuestType,
        onChanged: (v) => setState(() => selectedGuestType = v!),
        title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(description, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ),
        secondary: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
          child: Icon(icon, color: Colors.grey[600]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Choose who can rent your item first',
      subtitle: 'After your first renter, anyone can request to rent your item.',
      currentStep: 2,
      onNext: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PricingScreen())),
      child: Column(
        children: [
          _buildGuestOption(
            'any',
            'Any Leez user',
            'Get more rental requests by allowing anyone from the LEEZ community to request your item.',
            Icons.people,
          ),
          _buildGuestOption(
            'experienced',
            'An experienced renter',
            'Allow only users with at least 3 completed rentals or a positive rental history on LEEZ to request your item first.',
            Icons.star,
          ),
        ],
      ),
    );
  }
}

// Screen 3: Pricing
class PricingScreen extends StatefulWidget {
  @override
  _PricingScreenState createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  double basePrice = 1794.0;
  bool isEditing = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = basePrice.toInt().toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() => isEditing = true);
    _focusNode.requestFocus();
    _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
  }

  void _finishEditing() {
    setState(() {
      basePrice = double.tryParse(_controller.text) ?? basePrice;
      isEditing = false;
    });
    _focusNode.unfocus();
    HapticFeedback.lightImpact();
  }

  Widget _buildPriceDisplay() {
    return Center(
      child: GestureDetector(
        onTap: isEditing ? null : _startEditing,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('₹', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ),
            if (isEditing)
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  decoration: InputDecoration(border: InputBorder.none),
                  onSubmitted: (_) => _finishEditing(),
                  onTapOutside: (_) => _finishEditing(),
                ),
              )
            else ...[
              Text(
                basePrice.toInt().toString().replaceAllMapped(
                  RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                  (match) => '${match[1]},',
                ),
                style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, top: 16),
                child: IconButton(
                  onPressed: _startEditing,
                  icon: Icon(Icons.edit, size: 20, color: Colors.grey[600]),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Now, set a base price',
      currentStep: 3,
      onBack: () => Navigator.pop(context),
      onNext: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SafetyDetailsScreen())),
      child: Column(
        children: [
          SizedBox(height: 32),
          _buildPriceDisplay(),
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey[600]),
            ],
          ),
        ],
      ),
    );
  }
}




// Screen 4: Safety Details
class SafetyDetailsScreen extends StatefulWidget {
  @override
  _SafetyDetailsScreenState createState() => _SafetyDetailsScreenState();
}

class _SafetyDetailsScreenState extends State<SafetyDetailsScreen> {
  final Map<String, bool> safetyFeatures = {
    'GPS tracker installed': false,
    'Anti-theft lock included': false,
    'Dashcam installed': false,
  };

  Widget _buildSafetyOption(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title, style: TextStyle(fontSize: 16))),
          Switch(
            value: safetyFeatures[title]!,
            onChanged: (value) => setState(() => safetyFeatures[title] = value),
            activeColor: Colors.black,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Share item safety details',
      currentStep: 4,
      onBack: () => Navigator.pop(context),
      onNext: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Listing created successfully!')),
      ),
      nextText: 'Create listing',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Does your item include any of these safety features?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          SizedBox(height: 24),
          ...safetyFeatures.keys.map(_buildSafetyOption),
          SizedBox(height: 32),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Important things to know',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                SizedBox(height: 8),
                Text(
                  'Please disclose any built-in security features or accessories that help renters use and return your vehicle safely.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                SizedBox(height: 12),
                Text(
                  'Make sure your listing follows local regulations for vehicle rentals and includes honest safety information.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}