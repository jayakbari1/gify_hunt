import 'dart:typed_data';

class Validators {
  // Private constructor to prevent instantiation
  Validators._();

  // Required field validator
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  // URL validator
  static String? url(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'URL'} is required';
    }
    
    final urlPattern = RegExp(
      r'^https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&=]*)$',
    );
    
    if (!urlPattern.hasMatch(value.trim())) {
      return 'Please enter a valid URL (e.g., https://example.com)';
    }
    
    return null;
  }

  // Startup name validator
  static String? startupName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Startup name is required';
    }
    
    if (value.trim().length < 2) {
      return 'Startup name must be at least 2 characters';
    }
    
    if (value.trim().length > 50) {
      return 'Startup name must not exceed 50 characters';
    }
    
    return null;
  }

  // Email validator
  static String? email(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Email'} is required';
    }
    
    final emailPattern = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailPattern.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  // Phone number validator
  static String? phoneNumber(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Phone number'} is required';
    }
    
    final phonePattern = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    
    if (!phonePattern.hasMatch(value.trim())) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }

  // Minimum length validator
  static String? minLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    if (value.trim().length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters';
    }
    
    return null;
  }

  // Maximum length validator
  static String? maxLength(String? value, int maxLength, {String? fieldName}) {
    if (value != null && value.trim().length > maxLength) {
      return '${fieldName ?? 'This field'} must not exceed $maxLength characters';
    }
    
    return null;
  }

  // Combine multiple validators
  static String? Function(String?) combine(List<String? Function(String?)> validators) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }

  // Alphanumeric validator
  static String? alphanumeric(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    final alphanumericPattern = RegExp(r'^[a-zA-Z0-9\s]+$');
    
    if (!alphanumericPattern.hasMatch(value.trim())) {
      return '${fieldName ?? 'This field'} can only contain letters, numbers, and spaces';
    }
    
    return null;
  }

  // Numeric validator
  static String? numeric(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    if (double.tryParse(value.trim()) == null) {
      return '${fieldName ?? 'This field'} must be a valid number';
    }
    
    return null;
  }

  // GIF file validator - checks file extension
  static String? gifFile(String? fileName, {String? fieldName}) {
    if (fileName == null || fileName.trim().isEmpty) {
      return '${fieldName ?? 'GIF file'} is required';
    }

    final fileNameLower = fileName.toLowerCase();
    if (!fileNameLower.endsWith('.gif')) {
      return 'Please select a GIF file (.gif extension required)';
    }

    return null;
  }

  // GIF content validator - checks file signature (magic bytes)
  static String? gifContent(Uint8List? bytes, {String? fieldName}) {
    if (bytes == null || bytes.isEmpty) {
      return '${fieldName ?? 'GIF file'} is required';
    }

    if (bytes.length < 6) {
      return '${fieldName ?? 'GIF file'} is too small to be a valid GIF';
    }

    // Check for GIF87a signature: GIF87a (hex: 47 49 46 38 37 61)
    final gif87a = [0x47, 0x49, 0x46, 0x38, 0x37, 0x61];
    // Check for GIF89a signature: GIF89a (hex: 47 49 46 38 39 61)
    final gif89a = [0x47, 0x49, 0x46, 0x38, 0x39, 0x61];

    final header = bytes.sublist(0, 6);

    bool isValidGif = true;
    for (int i = 0; i < 6; i++) {
      if (header[i] != gif87a[i] && header[i] != gif89a[i]) {
        isValidGif = false;
        break;
      }
    }

    if (!isValidGif) {
      return '${fieldName ?? 'File'} is not a valid GIF file. Please select an actual GIF file.';
    }

    return null;
  }

  // File size validator
  static String? fileSize(int? bytes, int maxSizeInMB, {String? fieldName}) {
    if (bytes == null) {
      return '${fieldName ?? 'File'} is required';
    }

    final maxSizeInBytes = maxSizeInMB * 1024 * 1024; // Convert MB to bytes
    if (bytes > maxSizeInBytes) {
      return '${fieldName ?? 'File'} size must not exceed ${maxSizeInMB}MB';
    }

    return null;
  }

  // GIF dimensions validator (optional - checks if dimensions are reasonable for 88x31)
  static String? gifDimensions(int? width, int? height, {String? fieldName}) {
    if (width == null || height == null) {
      return null; // Skip validation if dimensions can't be determined
    }

    // Allow some flexibility but warn about non-standard dimensions
    const double aspectRatio = 88 / 31; // ~2.84
    final double actualRatio = width / height;

    // Check if aspect ratio is too different (more than 50% difference)
    if ((actualRatio - aspectRatio).abs() / aspectRatio > 0.5) {
      return '${fieldName ?? 'GIF'} dimensions ($width x $height) may not display optimally. Recommended: 88x31 pixels';
    }

    return null;
  }
}