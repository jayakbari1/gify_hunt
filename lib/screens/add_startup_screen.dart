import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/startup.dart';
import '../providers/startup_provider.dart';
import '../utils/validators.dart';

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
      backgroundColor: const Color(0xFF0A0A0A),
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
                  color: Colors.cyan,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan.withOpacity(_glowAnimation.value),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          const Text(
            'STARTUP SUBMISSION',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF1A1A1A),
      foregroundColor: Colors.cyan,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.cyan),
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
              Colors.black.withOpacity(0.85),
              Colors.black.withOpacity(0.95),
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
            gradient: const LinearGradient(colors: [Colors.cyan, Colors.blue]),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.cyan.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            'SYSTEM UPLOAD',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'STARTUP DEPLOYMENT',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
            shadows: [
              Shadow(color: Colors.cyan, blurRadius: 4, offset: Offset(0, 2)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Initialize your startup into the 88x31 matrix grid system',
          style: TextStyle(
            color: Colors.cyan.withOpacity(0.8),
            fontSize: 16,
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
        border: Border.all(color: Colors.cyan.withOpacity(0.3), width: 1),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A1A1A).withOpacity(0.8),
            const Color(0xFF0D1117).withOpacity(0.9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.1),
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
            Icon(icon, color: Colors.cyan, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.cyan,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.4),
              letterSpacing: 0.5,
            ),
            filled: true,
            fillColor: Colors.black.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.cyan.withOpacity(0.3),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.cyan.withOpacity(0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.cyan, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
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
            const Icon(Icons.file_upload, color: Colors.cyan, size: 16),
            const SizedBox(width: 8),
            const Text(
              'VISUAL ASSET UPLOAD',
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
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
              color: _selectedGifBytes != null
                  ? Colors.green.withOpacity(0.5)
                  : Colors.cyan.withOpacity(0.3),
              width: 2,
              style: BorderStyle.solid,
            ),
            color: Colors.black.withOpacity(0.2),
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
                            ? Colors.green
                            : Colors.cyan.withOpacity(_glowAnimation.value),
                        size: 32,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedGifBytes != null
                        ? 'FILE LOADED: $_selectedGifFileName'
                        : 'CLICK TO UPLOAD GIF',
                    style: TextStyle(
                      color: _selectedGifBytes != null
                          ? Colors.green
                          : Colors.cyan.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_selectedGifBytes == null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Optimal: 88x31 pixels',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
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
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(
                    color: Colors.cyan.withOpacity(
                      _isSubmitting ? 0.3 : _glowAnimation.value,
                    ),
                    width: 2,
                  ),
                ).copyWith(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.cyan.withOpacity(0.1);
                    }
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.cyan.withOpacity(0.05);
                    }
                    return Colors.cyan.withOpacity(0.02);
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
                            Colors.cyan.withOpacity(0.7),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'DEPLOYING...',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  )
                : const Text(
                    'DEPLOY STARTUP',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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
        border: Border.all(color: Colors.yellow.withOpacity(0.3), width: 1),
        color: Colors.yellow.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.yellow.withOpacity(0.8),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'SYSTEM REQUIREMENTS',
                style: TextStyle(
                  color: Colors.yellow.withOpacity(0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...const [
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
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 11,
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
      final bytes = await image.readAsBytes();
      setState(() {
        _selectedGifBytes = bytes;
        _selectedGifFileName = image.name;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedGifBytes == null) {
      _showSnackBar('Please upload a GIF file', isError: true);
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
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Submission successful!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
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
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError
            ? Colors.red.withOpacity(0.9)
            : Colors.green.withOpacity(0.9),
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
        const Text(
          'Join Our Startup Showcase',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Submit your startup to be featured in our 88x31 pixel showcase gallery',
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
        ),
      ],
    );
  }
}
