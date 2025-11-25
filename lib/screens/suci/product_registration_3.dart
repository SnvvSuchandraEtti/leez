import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'product_registration_4.dart'; // Make sure this import points to the file where AddTitleScreen is defined

class AddPhotos extends StatefulWidget {
  const AddPhotos({super.key});

  @override
  State<AddPhotos> createState() => _AddPhotosState();
}

class _AddPhotosState extends State<AddPhotos> {
  final List<XFile> selectedImages = [];
  final List<int> selectedIndexes = []; // stores selected indexes
  final ImagePicker _picker = ImagePicker();

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title:
                  const Text('Take Photo', style: TextStyle(color: Colors.white)),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  setState(() => selectedImages.add(image));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: const Text('Choose from Gallery',
                  style: TextStyle(color: Colors.white)),
              onTap: () async {
                Navigator.pop(context);
                final List<XFile> images = await _picker.pickMultiImage();
                if (images.isNotEmpty) {
                  setState(() => selectedImages.addAll(images));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toggleSelection(int index) {
    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        selectedIndexes.add(index);
      }
    });
  }

  void _deleteSelectedImages() {
    setState(() {
      selectedIndexes.sort((a, b) => b.compareTo(a)); // delete from back to avoid shifting
      for (var index in selectedIndexes) {
        selectedImages.removeAt(index);
      }
      selectedIndexes.clear();
    });
  }

void _goToNextScreen() {
  if (selectedImages.length >= 4) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTitleScreen(), // Your existing Screen2 widget
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final bool isSelectionMode = selectedIndexes.isNotEmpty;
    final bool canProceed = selectedImages.length >= 4;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Add Photos',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: selectedImages.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo_camera_outlined,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No photos added yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap the + button to add photos',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          itemCount: selectedImages.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                          ),
                          itemBuilder: (context, index) {
                            final image = selectedImages[index];
                            final isSelected = selectedIndexes.contains(index);
                            return GestureDetector(
                              onLongPress: () => _toggleSelection(index),
                              onTap: isSelectionMode
                                  ? () => _toggleSelection(index)
                                  : null, // prevent accidental preview
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey[300]!),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 6,
                                            offset: Offset(2, 4),
                                          ),
                                        ],
                                      ),
                                      child: Image.file(
                                        File(image.path),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: const Icon(Icons.check_circle,
                                            color: Colors.white, size: 36),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                );
              },
            ),
          ),
          // Bottom section with buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Add Photos Button (Bottom Left)
                ElevatedButton(
                  onPressed: _showImageSourceDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add, size: 18),
                      SizedBox(width: 8),

                    ],
                  ),
                ),
                
                const Spacer(), // Pushes Next button to the right
                // Next Button (Bottom Right)
                ElevatedButton(
                  onPressed: canProceed ? _goToNextScreen : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canProceed ? Colors.black : Colors.grey[300],
                    foregroundColor: canProceed ? Colors.white : Colors.grey[600],
                    elevation: canProceed ? 2 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  
                  child: Text(
                    canProceed ? 'Next' : 'Add ${4 - selectedImages.length} more photos',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}