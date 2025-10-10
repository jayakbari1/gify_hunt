import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web/web.dart' as web;

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/validators.dart';
import '../widgets/animated_rotating_title.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _featureRequestController = TextEditingController();

  bool _isSubmitting = false;

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
    _emailController.dispose();
    _featureRequestController.dispose();
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
            'FEEDBACK SYSTEM',
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
          fit: BoxFit.none,
          alignment: Alignment.center,
          repeat: ImageRepeat.repeat,
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
            'USER FEEDBACK',
            style: AppTextStyles.labelMedium.copyWith(letterSpacing: 1.5),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'FEATURE REQUEST PROTOCOL',
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
        // Animated rotating descriptive titles
        AnimatedRotatingTitle(
          titles: const [
            'Help us improve Gify with your feature suggestions',
            'Share your ideas for new functionality and enhancements',
            'Your feedback drives our development roadmap',
            'Together we build the future of micro-advertising',
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
          _buildNameField(),
          const SizedBox(height: 24),
          _buildEmailField(),
          const SizedBox(height: 24),
          _buildFeatureRequestField(),
          const SizedBox(height: 32),
          _buildSubmitButton(),
          const SizedBox(height: 24),
          _buildGuidelines(),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return _buildCyberTextField(
      controller: _nameController,
      label: 'USER IDENTIFIER',
      hint: 'Enter your name (optional)...',
      icon: Icons.person,
      validator: null, // Optional field
    );
  }

  Widget _buildEmailField() {
    return _buildCyberTextField(
      controller: _emailController,
      label: 'CONTACT EMAIL',
      hint: 'Enter your email (optional)...',
      icon: Icons.email,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          return Validators.email(value);
        }
        return null; // Optional field
      },
    );
  }

  Widget _buildFeatureRequestField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.lightbulb, color: AppColors.primary, size: 16),
            const SizedBox(width: 8),
            Text(
              'FEATURE REQUEST',
              style: AppTextStyles.labelMedium.copyWith(letterSpacing: 1.2),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _featureRequestController,
          validator: Validators.required,
          maxLines: 8,
          minLines: 4,
          style: AppTextStyles.bodyLarge.copyWith(letterSpacing: 0.5),
          decoration: InputDecoration(
            hintText: 'Describe your feature request in detail...',
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

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return ElevatedButton(
            onPressed: _isSubmitting ? null : _submitFeedback,
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
                        'TRANSMITTING...',
                        style: AppTextStyles.labelLarge.copyWith(
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  )
                : Text(
                    'SUBMIT FEEDBACK',
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
                'FEEDBACK GUIDELINES',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.warningWithOpacity(0.9),
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...const [
            '• Be specific about the feature you want',
            '• Include details about how it would work',
            '• Explain why this feature would be valuable',
            '• Name and email are optional but help us follow up',
            '• All feedback is reviewed and considered',
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

  Future<void> _submitFeedback() async {
    // Validate the form
    final isFormValid = _formKey.currentState!.validate();

    if (!isFormValid) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Prepare feedback data
      final feedbackData = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'featureRequest': _featureRequestController.text.trim(),
        'timestamp': DateTime.now().toIso8601String(),
        'userAgent': web.window.navigator.userAgent,
      };

      // Send email using a service (you'll need to implement this)
      await _sendFeedbackEmail(feedbackData);

      // On success: Navigate back and show toast
      if (mounted) {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: "Feedback submitted successfully!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.success,
          textColor: AppColors.textPrimary,
          fontSize: 16.0,
        );
      }
    } catch (e, s) {
      // On error: Show SnackBar
      _showSnackBar('Failed to submit feedback: $e', isError: true);
      debugPrintStack(stackTrace: s);
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> _sendFeedbackEmail(Map<String, dynamic> feedbackData) async {
    // For now, we'll use a simple approach with mailto
    // In a real app, you'd want to use a backend service or email API

    final subject = 'Gify Feature Request';
    final body = '''
New Feature Request from Gify User

Name: ${feedbackData['name'].isEmpty ? 'Anonymous' : feedbackData['name']}
Email: ${feedbackData['email'].isEmpty ? 'Not provided' : feedbackData['email']}
Timestamp: ${feedbackData['timestamp']}

Feature Request:
${feedbackData['featureRequest']}

User Agent: ${feedbackData['userAgent']}
''';

    final mailtoUrl = 'mailto:akbarijay1@gmail.com?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';

    // Open email client
    web.window.open(mailtoUrl, '_blank');

    // Alternative: Use a service like EmailJS or your backend API
    // For production, implement proper email sending
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