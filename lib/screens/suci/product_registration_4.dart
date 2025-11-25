import 'package:flutter/material.dart';
import 'product_registration_5.dart';

// Screen 1: Add Title Screen
class AddTitleScreen extends StatefulWidget {
  const AddTitleScreen({super.key});

  @override
  State<AddTitleScreen> createState() => _AddTitleScreenState();
}

class _AddTitleScreenState extends State<AddTitleScreen> {
  final TextEditingController _titleController = TextEditingController();
  final int maxCharacters = 50;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remainingCharacters = maxCharacters - _titleController.text.length;
    final canProceed = _titleController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Give your item a title',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Keep it short and clear  you can update it later.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _titleController,
              maxLength: maxCharacters,
              decoration: InputDecoration(
                hintText: 'Enter your title',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
                counterText: '',
                contentPadding: const EdgeInsets.all(16),
              ),
              style: const TextStyle(fontSize: 16),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            Text(
              '$remainingCharacters characters available',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canProceed
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateDescriptionScreen(),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canProceed ? Colors.black : Colors.grey[300],
                  foregroundColor: canProceed ? Colors.white : Colors.grey[600],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Screen 2: Create Description Screen
class CreateDescriptionScreen extends StatefulWidget {
  const CreateDescriptionScreen({super.key});

  @override
  State<CreateDescriptionScreen> createState() => _CreateDescriptionScreenState();
}

class _CreateDescriptionScreenState extends State<CreateDescriptionScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final int maxCharacters = 500;

  @override
  void initState() {
    super.initState();
    _descriptionController.text = "You’ll love how useful and well-maintained this item is during your rental";
    _descriptionController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remainingCharacters = maxCharacters - _descriptionController.text.length;
    final canProceed = _descriptionController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Describe your item',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Share important details about its condition, usage, and what renters should know.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _descriptionController,
                maxLength: maxCharacters,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                  counterText: '',
                ),
                style: const TextStyle(fontSize: 16),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$remainingCharacters characters available',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canProceed
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DescribePropertyScreen(),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canProceed ? Colors.black : Colors.grey[300],
                  foregroundColor: canProceed ? Colors.white : Colors.grey[600],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Screen 3: Describe Property Screen
class DescribePropertyScreen extends StatefulWidget {
  const DescribePropertyScreen({super.key});

  @override
  State<DescribePropertyScreen> createState() => _DescribePropertyScreenState();
}

class _DescribePropertyScreenState extends State<DescribePropertyScreen> {
  final List<String> selectedHighlights = [];

final List<Map<String, dynamic>> highlights = [
{'icon': Icons.verified_outlined, 'label': 'Well-maintained'},
{'icon': Icons.auto_awesome_outlined, 'label': 'Like New'},
{'icon': Icons.attach_money_outlined, 'label': 'Budget-friendly'},
{'icon': Icons.star_rate_outlined, 'label': 'Top Rated'},
{'icon': Icons.timelapse_outlined, 'label': 'Instant Availability'},
{'icon': Icons.lock_open_outlined, 'label': 'Easy Pickup'},
];

  void _toggleHighlight(String highlight) {
    setState(() {
      if (selectedHighlights.contains(highlight)) {
        selectedHighlights.remove(highlight);
      } else if (selectedHighlights.length < 2) {
        selectedHighlights.add(highlight);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final canProceed = selectedHighlights.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Highlight your item',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Choose up to 2 features. These help renters know what makes your item special.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2.5,
                ),
                itemCount: highlights.length,
                itemBuilder: (context, index) {
                  final highlight = highlights[index];
                  final isSelected = selectedHighlights.contains(highlight['label']);
                  final isDisabled = !isSelected && selectedHighlights.length >= 2;

                  return GestureDetector(
                    onTap: isDisabled ? null : () => _toggleHighlight(highlight['label']),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isDisabled ? Colors.grey[50] : Colors.white,
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Icon(
                              highlight['icon'],
                              size: 24,
                              color: isDisabled ? Colors.grey[400] : Colors.black,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              highlight['label'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isDisabled ? Colors.grey[400] : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
onPressed: canProceed
    ? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingSettingsScreen(),
          ),
        );
      }
    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canProceed ? Colors.black : Colors.grey[300],
                  foregroundColor: canProceed ? Colors.white : Colors.grey[600],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Demo app to show all screens
class PropertyListingApp extends StatelessWidget {
  const PropertyListingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Property Listing',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        fontFamily: 'SF Pro Display',
      ),
      home: const AddTitleScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}