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
}