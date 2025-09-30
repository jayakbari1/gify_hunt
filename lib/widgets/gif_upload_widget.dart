import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class GifUploadWidget extends StatefulWidget {
  final Uint8List? selectedFileBytes;
  final String? selectedFileName;
  final Function(Uint8List?, String?) onFileSelected;
  final String title;
  final String subtitle;
  final String? validationMessage;

  const GifUploadWidget({
    super.key,
    required this.selectedFileBytes,
    required this.selectedFileName,
    required this.onFileSelected,
    this.title = 'Upload Your GIF *',
    this.subtitle = 'Upload a 88x31 pixel GIF to represent your startup',
    this.validationMessage,
  });

  @override
  State<GifUploadWidget> createState() => _GifUploadWidgetState();
}

class _GifUploadWidgetState extends State<GifUploadWidget> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.subtitle,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        
        // Upload Area
        GestureDetector(
          onTap: _pickGifFile,
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.selectedFileBytes != null 
                    ? Colors.green 
                    : Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withValues(alpha: 0.3),
            ),
            child: widget.selectedFileBytes != null 
                ? _buildSelectedGifPreview() 
                : _buildUploadPlaceholder(),
          ),
        ),
        
        // Validation message
        if (widget.validationMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              widget.validationMessage!,
              style: TextStyle(
                color: Colors.red.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSelectedGifPreview() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 88,
          height: 31,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.green),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: kIsWeb 
                ? Image.memory(
                    widget.selectedFileBytes!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey,
                        child: const Icon(Icons.error, color: Colors.red),
                      );
                    },
                  )
                : Container(
                    color: Colors.grey,
                    child: const Icon(Icons.image, color: Colors.white),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        const Icon(Icons.check_circle, color: Colors.green, size: 20),
        const SizedBox(height: 4),
        Text(
          widget.selectedFileName ?? 'GIF selected successfully',
          style: const TextStyle(color: Colors.green, fontSize: 12),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: _pickGifFile,
          child: Text(
            'Tap to change',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.cloud_upload_outlined,
          size: 40,
          color: Colors.white.withValues(alpha: 0.6),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap to upload GIF',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Recommended: 88x31 pixels',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Future<void> _pickGifFile() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      
      if (image != null) {
        // For web, read the file as bytes
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          widget.onFileSelected(bytes, image.name);
        } else {
          // This shouldn't be used since we're focusing on web only
          debugPrint('Mobile platform not supported in this implementation');
        }
      }
    } catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }
}
