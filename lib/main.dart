import 'package:flutter/material.dart';
import 'package:gify/gify/resources.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
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
      body: SafeArea(
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

                // Grid View
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 88 / 31, // 88x31 aspect ratio
                      ),
                      itemCount: SvgGifs.gifPaths.length,
                      itemBuilder: (context, index) {
                        return GifContainer(
                          gifPath: SvgGifs.gifPaths[index],
                          index: index,
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
    );
  }
}

class GifContainer extends StatelessWidget {
  final String gifPath;
  final int index;

  const GifContainer({super.key, required this.gifPath, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 31,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(4),
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
        child: Image.asset(
          gifPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.withOpacity(0.3),
              child: Center(
                child: Text(
                  'GIF ${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
