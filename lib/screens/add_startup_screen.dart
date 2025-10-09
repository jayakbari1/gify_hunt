import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/startup.dart';
import '../providers/startup_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/validators.dart';
import '../widgets/animated_rotating_title.dart';

class AddStartupScreen extends StatefulWidget {
  const AddStartupScreen({super.key});

  @override
  State<AddStartupScreen> createState() => _AddStartupScreenState();
}

class _AddStartupScreenState extends State<AddStartupScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _emailController = TextEditingController();
  final _taglineController = TextEditingController();

  Uint8List? _selectedGifBytes;
  String? _selectedGifFileName;
  bool _isSubmitting = false;
  bool _gifValidationError = false;

  late AnimationController _fadeController;
  late AnimationController _glowController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _glowController.dispose();
    _nameController.dispose();
    _urlController.dispose();
    _emailController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryWithOpacity(_glowAnimation.value),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          Text(
            'STARTUP SUBMISSION',
            style: AppTextStyles.titleLarge.copyWith(letterSpacing: 2),
          ),
        ],
      ),
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.primary,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/circuit.gif'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundWithOpacity(0.85),
              AppColors.backgroundWithOpacity(0.95),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildFormContainer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.primary, Colors.blue]),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryWithOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            'SYSTEM UPLOAD',
            style: AppTextStyles.labelMedium.copyWith(letterSpacing: 1.5),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'STARTUP DEPLOYMENT',
          style: AppTextStyles.displayMedium.copyWith(
            letterSpacing: 3,
            shadows: [
              Shadow(
                color: AppColors.primary,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Animated rotating descriptive titles (one-by-one every 10 seconds)
        AnimatedRotatingTitle(
          titles: const [
            'Initialize your startup into the 88x31 matrix grid system',
            'Get featured in the micro-banner showcase (88×31)',
            'Fast approval • Minimal friction • Global reach',
            'Professional creatives • Curated gallery • High visibility',
          ],
          interval: const Duration(seconds: 10),
          textStyle: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.primaryWithOpacity(0.9),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildFormContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryWithOpacity(0.3), width: 1),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceWithOpacity(0.8),
            const Color(0xFF0D1117).withValues(alpha: 0.9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryWithOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildStartupNameField(),
          const SizedBox(height: 24),
          _buildWebsiteUrlField(),
          const SizedBox(height: 24),
          _buildEmailField(),
          const SizedBox(height: 24),
          _buildTaglineField(),
          const SizedBox(height: 24),
          _buildGifUploadSection(),
          const SizedBox(height: 32),
          _buildSubmitButton(),
          const SizedBox(height: 24),
          _buildGuidelines(),
        ],
      ),
    );
  }

  Widget _buildStartupNameField() {
    return _buildCyberTextField(
      controller: _nameController,
      label: 'STARTUP IDENTIFIER',
      hint: 'Enter startup name...',
      icon: Icons.business_center,
      validator: Validators.startupName,
    );
  }

  Widget _buildWebsiteUrlField() {
    return _buildCyberTextField(
      controller: _urlController,
      label: 'NETWORK ADDRESS',
      hint: 'https://your-startup.com',
      icon: Icons.link,
      keyboardType: TextInputType.url,
      validator: Validators.combine([
        (value) => Validators.required(value, fieldName: 'Website URL'),
        Validators.url,
      ]),
    );
  }

  Widget _buildEmailField() {
    return _buildCyberTextField(
      controller: _emailController,
      label: 'CONTACT EMAIL',
      hint: 'Enter contact email...',
      icon: Icons.email,
      keyboardType: TextInputType.emailAddress,
      validator: Validators.email,
    );
  }

  Widget _buildTaglineField() {
    return _buildCyberTextField(
      controller: _taglineController,
      label: 'TAGLINE',
      hint: 'Enter startup tagline...',
      icon: Icons.short_text,
      validator: Validators.required,
    );
  }

  Widget _buildCyberTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(letterSpacing: 1.2),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          style: AppTextStyles.bodyLarge.copyWith(letterSpacing: 0.5),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
            filled: true,
            fillColor: AppColors.backgroundWithOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.primaryWithOpacity(0.3),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.primaryWithOpacity(0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.error, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGifUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.file_upload, color: AppColors.primary, size: 16),
            const SizedBox(width: 8),
            Text(
              'VISUAL ASSET UPLOAD',
              style: AppTextStyles.labelMedium.copyWith(letterSpacing: 1.2),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _gifValidationError
                  ? AppColors.error
                  : _selectedGifBytes != null
                  ? AppColors.successWithOpacity(0.5)
                  : AppColors.primaryWithOpacity(0.3),
              width: 2,
              style: BorderStyle.solid,
            ),
            color: AppColors.backgroundWithOpacity(0.2),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: _pickGifFile,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _glowAnimation,
                    builder: (context, child) {
                      return Icon(
                        _selectedGifBytes != null
                            ? Icons.check_circle
                            : Icons.cloud_upload,
                        color: _selectedGifBytes != null
                            ? AppColors.success
                            : AppColors.primaryWithOpacity(
                                _glowAnimation.value,
                              ),
                        size: 32,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedGifBytes != null
                        ? 'FILE LOADED: $_selectedGifFileName'
                        : 'CLICK TO UPLOAD GIF FILE',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: _selectedGifBytes != null
                          ? AppColors.success
                          : AppColors.primaryWithOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_selectedGifBytes == null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Only .gif files accepted',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondaryWithOpacity(0.4),
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (_gifValidationError) ...[
          const SizedBox(height: 8),
          const Text(
            'Please upload a GIF file',
            style: TextStyle(
              color: AppColors.error,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return ElevatedButton(
            onPressed: _isSubmitting ? null : _submitForm,
            style:
                ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: AppColors.textPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(
                    color: AppColors.primaryWithOpacity(
                      _isSubmitting ? 0.3 : _glowAnimation.value,
                    ),
                    width: 2,
                  ),
                ).copyWith(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.pressed)) {
                      return AppColors.primaryWithOpacity(0.1);
                    }
                    if (states.contains(WidgetState.hovered)) {
                      return AppColors.primaryWithOpacity(0.05);
                    }
                    return AppColors.primaryWithOpacity(0.02);
                  }),
                ),
            child: _isSubmitting
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryWithOpacity(0.7),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'DEPLOYING...',
                        style: AppTextStyles.labelLarge.copyWith(
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  )
                : Text(
                    'DEPLOY STARTUP',
                    style: AppTextStyles.labelLarge.copyWith(
                      letterSpacing: 1.5,
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildGuidelines() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.warningWithOpacity(0.3), width: 1),
        color: AppColors.warningWithOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.warningWithOpacity(0.8),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'SYSTEM REQUIREMENTS',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.warningWithOpacity(0.9),
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...const [
            '• File format: GIF only (.gif extension + valid GIF content required)',
            '• GIF dimensions: 88x31 pixels (optimal)',
            '• File size limit: 2MB maximum',
            '• Network address must be accessible',
            '• Content review process: 24-48 hours',
            '• Professional content only',
          ].map(
            (guideline) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                guideline,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondaryWithOpacity(0.7),
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickGifFile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Validate file extension
      final extensionError = Validators.gifFile(image.name);
      if (extensionError != null) {
        _showSnackBar(extensionError, isError: true);
        return;
      }

      final bytes = await image.readAsBytes();

      // Validate file content (magic bytes)
      final contentError = Validators.gifContent(bytes);
      if (contentError != null) {
        _showSnackBar(contentError, isError: true);
        return;
      }

      // Validate file size (2MB limit)
      final sizeError = Validators.fileSize(bytes.length, 2);
      if (sizeError != null) {
        _showSnackBar(sizeError, isError: true);
        return;
      }

      // Optional: Validate dimensions (if we can determine them)
      // For now, we'll skip dimension validation as it requires additional packages
      // and the guidelines already mention the optimal dimensions

      setState(() {
        _selectedGifBytes = bytes;
        _selectedGifFileName = image.name;
        _gifValidationError =
            false; // Clear validation error when GIF is selected
      });

      _showSnackBar('GIF file uploaded successfully!', isError: false);
    }
  }

  Future<void> _submitForm() async {
    // First validate the form fields
    final isFormValid = _formKey.currentState!.validate();

    // Check if GIF is uploaded
    final isGifValid = _selectedGifBytes != null;

    // Update validation error state
    setState(() {
      _gifValidationError = !isGifValid;
    });

    if (!isFormValid || !isGifValid) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Convert bytes to base64 for web storage
      final base64Gif = Startup.bytesToBase64(_selectedGifBytes!);

      final startup = Startup(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        websiteUrl: _urlController.text.trim(),
        email: _emailController.text.trim(),
        tagline: _taglineController.text.trim(),
        gifPath: base64Gif,
        gifFileName: _selectedGifFileName,
        createdAt: DateTime.now(),
        isUserSubmitted: true,
      );

      await Provider.of<StartupProvider>(
        context,
        listen: false,
      ).addStartup(startup);

      // On success: Navigate back to home and show toast
      if (mounted) {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: "Submission successful!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.success,
          textColor: AppColors.textPrimary,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      // On error: Show SnackBar and reset form state
      _showSnackBar('System error: $e', isError: true);
      _resetForm();
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _urlController.clear();
    _emailController.clear();
    _taglineController.clear();
    setState(() {
      _selectedGifBytes = null;
      _selectedGifFileName = null;
      _gifValidationError = false;
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: AppColors.textPrimary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError
            ? AppColors.errorWithOpacity(0.9)
            : AppColors.successWithOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Join Our Startup Showcase',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Submit your startup to be featured in our 88x31 pixel showcase gallery',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondaryWithOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
