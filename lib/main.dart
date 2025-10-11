import 'dart:async';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:web/web.dart' as web;

import '../models/startup.dart';
import '../widgets/animated_rotating_title.dart';
import '../widgets/cyber_action_button.dart';
import 'config/firebase_options_dev.dart';
import 'constants/str_constants.dart';
import 'providers/startup_provider.dart';
import 'screens/about_us_page.dart';
import 'screens/add_startup_screen.dart';
import 'screens/feedback_screen.dart';
import 'theme/app_colors.dart';
import 'theme/app_text_styles.dart';
import 'theme/app_theme.dart';
import 'utils/validators.dart';

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
      child: ShowCaseWidget(
        builder: (context) => MaterialApp(
          title: 'Gify',
          theme: AppTheme.theme,
          home: const HomePage(),
        ),
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Showcase keys
  final GlobalKey _menuKey = GlobalKey();
  final GlobalKey _spotlightKey = GlobalKey();
  final GlobalKey _addStartupKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _resetTimer();

    // Check if showcase has been shown before
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowShowcase();
    });
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

  void _checkAndShowShowcase() {
    // Check localStorage for showcase flag
    final hasShownShowcase =
        web.window.localStorage.getItem('hasShownShowcase') == 'true';

    if (!hasShownShowcase) {
      // Start showcase
      ShowCaseWidget.of(
        context,
      ).startShowCase([_menuKey, _spotlightKey, _addStartupKey]);

      // Mark as shown
      web.window.localStorage.setItem('hasShownShowcase', 'true');
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

    // Don't show dialog if drawer is open
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) return;

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
                                web.window.open(
                                  Validators.normalizeUrl(startup.websiteUrl),
                                  '_blank',
                                );
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

  Widget _buildDrawer() {
    return Container(
      width:
          MediaQuery.of(context).size.width *
          0.5, // Reduced from 0.7 to 0.5 for better UX
      decoration: BoxDecoration(
        color: Colors.transparent, // Fully transparent background
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        border: Border.all(color: AppColors.primaryWithOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryWithOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(5, 0),
          ),
        ],
      ),
      child: Container(
        // Circuit background like add_startup_screen
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/circuit.gif'),
            fit: BoxFit.none,
            alignment: Alignment.center,
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: Container(
          // Gradient overlay like add_startup_screen
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
          child: Column(
            children: [
              // Header with close button - cyber styled (removed nested border radius)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, Colors.blue],
                  ),
                  border: Border.all(
                    color: AppColors.primaryWithOpacity(0.5),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryWithOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryWithOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryWithOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Gify',
                          style: AppTextStyles.titleLarge.copyWith(
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: AppColors.primary,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Close button - cyber styled
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryWithOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primaryWithOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.white, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
              // Menu items - cyber styled
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      // About Us menu item - cyber styled
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primaryWithOpacity(0.3),
                            width: 1,
                          ),
                          color: AppColors.surfaceWithOpacity(0.8),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryWithOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryWithOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primaryWithOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.info_outline,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          title: Text(
                            'About Us',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.primary,
                            size: 16,
                          ),
                          onTap: () {
                            Navigator.pop(context); // Close drawer
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AboutUsPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      // Feedback menu item - cyber styled
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primaryWithOpacity(0.3),
                            width: 1,
                          ),
                          color: AppColors.surfaceWithOpacity(0.8),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryWithOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryWithOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primaryWithOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.feedback,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          title: Text(
                            'Feedback',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.primary,
                            size: 16,
                          ),
                          onTap: () {
                            Navigator.pop(context); // Close drawer
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FeedbackScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      // Add more menu items here if needed
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
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
                          children: [
                            // Hamburger menu icon - cyber styled
                            Showcase(
                              key: _menuKey,
                              title: 'Navigation Menu',
                              description:
                                  'Access app information, contact details, and provide feedback to help us improve',
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryWithOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.primaryWithOpacity(0.5),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryWithOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    _scaffoldKey.currentState?.isDrawerOpen ??
                                            false
                                        ? Icons.close
                                        : Icons.menu,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    if (_scaffoldKey
                                            .currentState
                                            ?.isDrawerOpen ??
                                        false) {
                                      _scaffoldKey.currentState?.closeDrawer();
                                    } else {
                                      _scaffoldKey.currentState?.openDrawer();
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Centered rotating hero title for better first impression
                            Expanded(
                              child: Center(
                                child: AnimatedRotatingTitle(
                                  titles: const [
                                    'Gify — Micro Banner Marketplace',
                                    'Showcase 88×31 GIFs • Curated & Fast',
                                    'Micro-ads that drive attention',
                                  ],
                                  interval: Duration(seconds: 10),
                                  textStyle: AppTextStyles.displayLarge,
                                ),
                              ),
                            ),
                            // Spotlight Toggle (responsive)
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final isNarrow = constraints.maxWidth < 360;
                                return Showcase(
                                  key: _spotlightKey,
                                  title: 'Spotlight Feature',
                                  description:
                                      'Toggle to display featured startup highlights periodically',
                                  child: CyberActionButton(
                                    icon: Icons.auto_awesome,
                                    text: '',
                                    // Always show only icon, no text
                                    isEnabled: _isSpotlightEnabled,
                                    compact: true,
                                    // Always compact to hide text
                                    trailingWidget: Transform.scale(
                                      scale: isNarrow ? 0.7 : 0.85,
                                      child: Switch(
                                        value: _isSpotlightEnabled,
                                        onChanged: _toggleSpotlight,
                                        activeColor: AppColors.primary,
                                        activeTrackColor:
                                            AppColors.primaryWithOpacity(0.3),
                                        inactiveThumbColor:
                                            AppColors.textPrimaryWithOpacity(
                                              0.7,
                                            ),
                                        inactiveTrackColor:
                                            AppColors.textPrimaryWithOpacity(
                                              0.2,
                                            ),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ),
                                  ),
                                );
                              },
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
            Showcase(
              key: _addStartupKey,
              title: 'Add Your Startup',
              description:
                  'Join our curated marketplace and get your startup featured in our professional 88×31 pixel showcase',
              child: CyberActionButton(
                icon: Icons.add_business,
                text: 'Add Startup',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddStartupScreen()),
                ),
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
        onTap: () => web.window.open(
          Validators.normalizeUrl(widget.websiteUrl),
          '_blank',
        ),
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
                child: SizedBox(width: 40, height: 80, child: _buildImage()),
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
