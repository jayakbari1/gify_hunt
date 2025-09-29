import 'dart:async';
import 'dart:html' as html;
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/startup.dart';
import 'config/firebase_options_dev.dart';
import 'providers/startup_provider.dart';
import 'constants/str_constants.dart';
import 'screens/add_startup_screen.dart';

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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startTimer();
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
      _startTimer();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _showRandomStartupDialog();
    });
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

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismiss by tapping outside
      builder: (BuildContext context) {
        // Auto close after 10 seconds
        Timer(const Duration(seconds: 10), () {
          if (Navigator.of(context).canPop()) {
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
                  color: Colors.white.withOpacity(0.95), // Slight transparency to blend with GIF
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black, width: 2),
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
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontFamily: 'Courier',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        if (_dialogCount % 2 == 1) ...[
                          Text(
                            startup.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Courier',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                        ],
                        Text(
                          '"${startup.tagline}"',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Courier',
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
                                html.window.open(startup.websiteUrl, '_blank');
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: const Text(
                                StrConstants.visitSite,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: const Text(
                                StrConstants.cancel,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
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
                        icon: const Icon(Icons.close, color: Colors.black, size: 28),
                        onPressed: () => Navigator.of(context).pop(),
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
      _isDialogShowing = false;
    });
  }

  int _calculateCrossAxisCount(double screenWidth) {
    const double containerWidth = 88.0;
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
                fit: BoxFit.cover,
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
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        child: const Text(
                          'Welcome to Gify',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 4,
                                color: Colors.black45,
                              ),
                            ],
                          ),
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
                                      childAspectRatio: 88 / 31,
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
            FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddStartupScreen()),
              ),
              backgroundColor: Colors.cyan.withOpacity(0.9),
              foregroundColor: Colors.white,
              elevation: 8,
              extendedPadding: const EdgeInsets.symmetric(horizontal: 20),
              icon: const Icon(Icons.add_business, size: 20),
              label: const Text(
                'Add Startup',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
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
        onTap: () => html.window.open(widget.websiteUrl, '_blank'),
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
                child: Container(
                  width: 88,
                  height: 31,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 0.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: _buildImage(),
                  ),
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
        fit: BoxFit.cover,
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
                    Colors.cyan.withOpacity(0.5),
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
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget();
        },
      );
    }
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey.withOpacity(0.3),
      child: Center(
        child: Text(
          'GIF ${widget.index + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
