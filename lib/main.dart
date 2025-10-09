import 'dart:async';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web/web.dart' as web;

import '../models/startup.dart';
import 'config/firebase_options_dev.dart';
import 'constants/str_constants.dart';
import 'providers/startup_provider.dart';
import 'screens/add_startup_screen.dart';
import '../widgets/cyber_action_button.dart';
import 'utils/validators.dart';
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';
import 'theme/app_text_styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptionsDev.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StartupProvider()..loadStartups(),
      child: MaterialApp(
        title: 'Gify',
        theme: AppTheme.theme,
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  Timer? _timer;
  bool _isDialogShowing = false;
  int _dialogCount = 0;
  StartupProvider? _provider;
  bool _isSpotlightEnabled = true; // New state for spotlight toggle

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _resetTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _provider = Provider.of<StartupProvider>(context, listen: false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _timer?.cancel();
      _timer = null;
    } else if (state == AppLifecycleState.resumed) {
      _resetTimer();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  // Toggle spotlight feature
  void _toggleSpotlight(bool value) {
    setState(() {
      _isSpotlightEnabled = value;
    });

    if (!value) {
      // Cancel timer when spotlight is disabled
      _timer?.cancel();
    } else {
      // Restart timer when spotlight is enabled
      _resetTimer();
    }
  }

  void _startTimer() {
    if (!_isSpotlightEnabled) {
      return; // Don't start timer if spotlight is disabled
    }

    _timer?.cancel(); // Cancel existing timer
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _showRandomStartupDialog();
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    if (_isSpotlightEnabled) {
      _startTimer();
    }
  }

  void _showRandomStartupDialog() {
    if (!mounted || _isDialogShowing || _provider == null) return;

    // Don't show dialog if HomePage is not the current route
    if (ModalRoute.of(context)?.isCurrent != true) return;

    final approvedStartups = _provider!.startups
        .where((s) => s.status == 'approved')
        .toList();
    if (approvedStartups.isEmpty) return;

    final random = Random();
    final startup = approvedStartups[random.nextInt(approvedStartups.length)];

    _isDialogShowing = true;
    _dialogCount++;

    Timer? autoCloseTimer;

    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismiss by tapping outside
      builder: (BuildContext context) {
        // Auto close after 10 seconds
        autoCloseTimer = Timer(const Duration(seconds: 10), () {
          if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              // Background GIF with very low opacity filling the dialog
              Positioned.fill(
                child: Opacity(
                  opacity: 0.05, // Very low opacity for subtle animation
                  child: Image.memory(
                    Startup.base64ToBytes(startup.gifPath),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(),
                  ),
                ),
              ),
              // Foreground content
              Container(
                width: 450,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.textPrimary.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.background, width: 2),
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 40), // Space for close button
                        Text(
                          _dialogCount % 2 == 1
                              ? StrConstants.startupSpotlight
                              : StrConstants.taglineFlash,
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: AppColors.background,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          startup.name,
                          style: AppTextStyles.titleLarge.copyWith(
                            color: AppColors.background,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '"${startup.tagline}"',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.background,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        // Buttons row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                autoCloseTimer?.cancel();
                                web.window.open(Validators.normalizeUrl(startup.websiteUrl), '_blank');
                                Navigator.of(context).pop();
                                _resetTimer(); // Reset timer when user takes action
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.background,
                                foregroundColor: AppColors.textPrimary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: Text(
                                StrConstants.visitSite,
                                style: AppTextStyles.button,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                autoCloseTimer?.cancel();
                                Navigator.of(context).pop();
                                _resetTimer(); // Reset timer when user takes action
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                foregroundColor: AppColors.background,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: Text(
                                StrConstants.cancel,
                                style: AppTextStyles.button,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: AppColors.background,
                          size: 28,
                        ),
                        onPressed: () {
                          autoCloseTimer?.cancel();
                          Navigator.of(context).pop();
                          _resetTimer(); // Reset timer when user closes dialog
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      autoCloseTimer?.cancel();
      _isDialogShowing = false;
      _resetTimer(); // Reset timer when dialog is dismissed by any means
    });
  }

  int _calculateCrossAxisCount(double screenWidth) {
    const double containerWidth = 40.0;
    const double spacing = 8.0;
    const double padding = 16.0;
    double availableWidth = screenWidth - (padding * 2);
    int crossAxisCount = (availableWidth / (containerWidth + spacing)).floor();
    if (crossAxisCount < 2) return 2;
    if (screenWidth > 1200) return crossAxisCount.clamp(2, 12);
    if (screenWidth > 800) return crossAxisCount.clamp(2, 8);
    return crossAxisCount.clamp(2, 6);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/circuit.gif'),
                fit: BoxFit.none,
                alignment: Alignment.center,
                repeat: ImageRepeat.repeat,
              ),
            ),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = _calculateCrossAxisCount(
                    constraints.maxWidth,
                  );
                  return Column(
                    children: [
                      // Header with title and spotlight toggle
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Title
                            Text(
                              'Welcome to Gify',
                              style: AppTextStyles.displayLarge,
                            ),
                            // Spotlight Toggle
                            CyberActionButton(
                              icon: Icons.auto_awesome,
                              text: 'Spotlight',
                              isEnabled: _isSpotlightEnabled,
                              trailingWidget: Transform.scale(
                                scale: 0.8,
                                child: Switch(
                                  value: _isSpotlightEnabled,
                                  onChanged: _toggleSpotlight,
                                  activeColor: AppColors.primary,
                                  activeTrackColor: AppColors.primaryWithOpacity(0.3),
                                  inactiveThumbColor: AppColors.textPrimaryWithOpacity(0.7),
                                  inactiveTrackColor: AppColors.textPrimaryWithOpacity(0.2),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            bottom: 80.0,
                          ),
                          child: Consumer<StartupProvider>(
                            builder: (context, provider, child) {
                              final approvedStartups = provider.startups
                                  .where((s) => s.status == 'approved')
                                  .toList();
                              return GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: 8.0,
                                      mainAxisSpacing: 8.0,
                                      childAspectRatio: 40 / 80,
                                    ),
                                itemCount: approvedStartups.length,
                                itemBuilder: (context, index) {
                                  final startup = approvedStartups[index];
                                  return GifContainer(
                                    gifPath: startup.gifPath,
                                    index: index,
                                    isUserSubmitted: startup.isUserSubmitted,
                                    name: startup.name,
                                    websiteUrl: startup.websiteUrl,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CyberActionButton(
              icon: Icons.add_business,
              text: 'Add Startup',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddStartupScreen()),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class GifContainer extends StatefulWidget {
  final String gifPath;
  final int index;
  final bool isUserSubmitted;
  final String name;
  final String websiteUrl;

  const GifContainer({
    super.key,
    required this.gifPath,
    required this.index,
    this.isUserSubmitted = false,
    required this.name,
    required this.websiteUrl,
  });

  @override
  State<GifContainer> createState() => _GifContainerState();
}

class _GifContainerState extends State<GifContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.name,
      child: GestureDetector(
        onTap: () => web.window.open(Validators.normalizeUrl(widget.websiteUrl), '_blank'),
        child: MouseRegion(
          onEnter: (_) {
            _animationController.forward();
          },
          onExit: (_) {
            _animationController.reverse();
          },
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: SizedBox(
                  width: 40,
                  height: 80,
                  child: _buildImage(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (widget.isUserSubmitted) {
      final dataUrl = 'data:image/gif;base64,${widget.gifPath}';
      return Image.network(
        dataUrl,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.transparent,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryWithOpacity(0.5),
                  ),
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget();
        },
      );
    } else {
      return Image.asset(
        widget.gifPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget();
        },
      );
    }
  }

  Widget _buildErrorWidget() {
    return Container(); // Empty container - no background or error display
  }
}
