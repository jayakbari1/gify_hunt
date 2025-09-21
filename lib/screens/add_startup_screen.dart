import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:typed_data';
import '../models/startup.dart';
import '../models/gif_data_dm.dart';
import '../providers/startup_provider.dart';
import '../utils/validators.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/gif_upload_widget.dart';
import '../widgets/custom_submit_button.dart';
import '../widgets/guidelines_widget.dart';
import '../data/comprehensive_dummy_gif_data.dart';

class AddStartupScreen extends StatefulWidget {
  const AddStartupScreen({super.key});

  @override
  State<AddStartupScreen> createState() => _AddStartupScreenState();
}

class _AddStartupScreenState extends State<AddStartupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  
  Uint8List? _selectedGifBytes;
  String? _selectedGifFileName;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Submit Your Startup'),
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      elevation: 0,
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
        color: Colors.black.withOpacity(0.8),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 30),
                  _buildStartupNameField(),
                  const SizedBox(height: 20),
                  _buildWebsiteUrlField(),
                  const SizedBox(height: 20),
                  _buildGifUploadSection(),
                  const SizedBox(height: 30),
                  _buildSubmitButton(),
                  const SizedBox(height: 20),
                  _buildGuidelines(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const HeaderWidget();
  }

  Widget _buildStartupNameField() {
    return CustomTextFormField(
      controller: _nameController,
      label: 'Startup Name *',
      hint: 'Enter your startup name',
      icon: Icons.business,
      validator: Validators.startupName,
    );
  }

  Widget _buildWebsiteUrlField() {
    return CustomTextFormField(
      controller: _urlController,
      label: 'Website URL *',
      hint: 'https://your-startup.com',
      icon: Icons.link,
      keyboardType: TextInputType.url,
      validator: Validators.combine([
        (value) => Validators.required(value, fieldName: 'Website URL'),
        Validators.url,
      ]),
    );
  }

  Widget _buildGifUploadSection() {
    return GifUploadWidget(
      selectedFileBytes: _selectedGifBytes,
      selectedFileName: _selectedGifFileName,
      onFileSelected: (bytes, fileName) {
        setState(() {
          _selectedGifBytes = bytes;
          _selectedGifFileName = fileName;
        });
      },
      validationMessage: _selectedGifBytes == null ? 'Please select a GIF file' : null,
    );
  }

  Widget _buildSubmitButton() {
    return CustomSubmitButton(
      onPressed: _submitForm,
      text: 'Submit Startup',
      isLoading: _isSubmitting,
    );
  }

  Widget _buildGuidelines() {
    return const GuidelinesWidget(
      guidelines: [
        '• GIF should be 88x31 pixels for best display',
        '• File size should be under 2MB',
        '• Make sure your website URL is accessible',
        '• Your startup will be reviewed before publishing',
        '• Keep content appropriate and professional',
      ],
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedGifBytes == null) {
      _showSnackBar('Please select a GIF file', isError: true);
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
        gifPath: base64Gif, // Store as base64 string
        gifFileName: _selectedGifFileName,
        createdAt: DateTime.now(),
        isUserSubmitted: true,
      );

      // Also add to GIF data for hover functionality
      final gifData = GifDataDm(
        id: DummyGifData.getNextId(),
        gifName: _selectedGifFileName ?? 'user_gif.gif',
        businessName: _nameController.text.trim(),
        websiteUrl: _urlController.text.trim(),
        description: 'User submitted startup',
        gifPath: base64Gif,
        isUserSubmitted: true,
        createdAt: DateTime.now(),
      );
      
      DummyGifData.addGifData(gifData);

      final success = await Provider.of<StartupProvider>(context, listen: false)
          .addStartup(startup);

      if (success) {
        _showSnackBar('Startup submitted successfully!');
        Navigator.pop(context);
      } else {
        _showSnackBar('Failed to submit startup. Please try again.', isError: true);
      }
    } catch (e) {
      _showSnackBar('An error occurred: $e', isError: true);
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
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
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}