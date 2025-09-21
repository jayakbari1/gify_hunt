import 'package:flutter/material.dart';
import 'package:gify/gify/resources.dart';
import 'package:provider/provider.dart';

import 'data/comprehensive_dummy_gif_data.dart';
import 'models/startup.dart';
import 'providers/startup_provider.dart';
import 'screens/add_startup_screen.dart';

void main() {
  // Initialize comprehensive dummy data for all GIFs
  DummyGifData.initializeDummyData();
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Calculate responsive grid cross axis count
  int _calculateCrossAxisCount(double screenWidth) {
    // 88px container width + spacing
    const double containerWidth = 88.0;
    const double spacing = 8.0;
    const double padding = 16.0;

    // Calculate available width
    double availableWidth = screenWidth - (padding * 2);

    // Calculate how many containers can fit
    int crossAxisCount = (availableWidth / (containerWidth + spacing)).floor();

    // Ensure minimum of 2 and maximum based on screen size
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
          // Main content
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
                      // Header
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

                      // Grid View with proper padding for FAB
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            bottom: 80.0, // Extra bottom padding for FAB
                          ),
                          child: Consumer<StartupProvider>(
                            builder: (context, provider, child) {
                              final allGifs = <Map<String, dynamic>>[];

                              // Add static GIFs
                              for (
                                int i = 0;
                                i < SvgGifs.gifPaths.length;
                                i++
                              ) {
                                allGifs.add({
                                  'path': SvgGifs.gifPaths[i],
                                  'isUserSubmitted': false,
                                });
                              }

                              // Add user submitted GIFs
                              for (final startup in provider.startups) {
                                allGifs.add({
                                  'path': startup.gifPath,
                                  'isUserSubmitted': startup.isUserSubmitted,
                                });
                              }

                              return GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: 8.0,
                                      mainAxisSpacing: 8.0,
                                      childAspectRatio: 88 / 31,
                                    ),
                                itemCount: allGifs.length,
                                itemBuilder: (context, index) {
                                  final gifData = allGifs[index];
                                  return GifContainer(
                                    gifPath: gifData['path'],
                                    index: index,
                                    isUserSubmitted: gifData['isUserSubmitted'],
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
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddStartupScreen()),
            );
          },
          backgroundColor: Colors.cyan.withOpacity(0.9),
          foregroundColor: Colors.white,
          elevation: 8,
          extendedPadding: const EdgeInsets.symmetric(horizontal: 20),
          icon: const Icon(Icons.add_business, size: 20),
          label: const Text(
            'Add Startup',
            style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
          ),
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

  const GifContainer({
    super.key,
    required this.gifPath,
    required this.index,
    this.isUserSubmitted = false,
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
    return MouseRegion(
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
    );
  }

  Widget _buildImage() {
    // Check if this is a base64 encoded string (user-submitted gif)
    if (widget.isUserSubmitted &&
        (widget.gifPath.contains('data:') ||
            widget.gifPath.startsWith('/9j/') ||
            widget.gifPath.startsWith('iVBOR') ||
            widget.gifPath.contains('base64'))) {
      try {
        // For base64 strings, decode and use Image.memory
        final bytes = Startup.base64ToBytes(widget.gifPath);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorWidget();
          },
        );
      } catch (e) {
        return _buildErrorWidget();
      }
    } else {
      // For asset images, use Image.asset
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
