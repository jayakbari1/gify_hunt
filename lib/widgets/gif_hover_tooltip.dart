import 'package:flutter/material.dart';
import '../models/gif_data_dm.dart';

class GifHoverTooltip extends StatelessWidget {
  final GifDataDm? gifData;
  final int gridNumber;
  final Offset mousePosition;
  final Size screenSize;

  const GifHoverTooltip({
    Key? key,
    required this.gifData,
    required this.gridNumber,
    required this.mousePosition,
    required this.screenSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure we always show something, even if gifData is null
    final displayBusinessName = gifData?.businessName ?? 'Unknown Business #${gridNumber}';
    final displayGifName = gifData?.gifName ?? 'Unknown GIF';
    final displayDescription = gifData?.description ?? 'No description available';
    final displayWebsiteUrl = gifData?.websiteUrl;
    final isUserSubmitted = gifData?.isUserSubmitted ?? false;

    // Calculate optimal position with smart edge detection
    const tooltipWidth = 280.0;
    const tooltipHeight = 140.0;
    const margin = 20.0;
    const arrowSize = 8.0;

    // Start with preferred position (above and centered)
    double left = mousePosition.dx - (tooltipWidth / 2);
    double top = mousePosition.dy - tooltipHeight - arrowSize - 10;
    
    // Determine if we should show above or below
    bool showAbove = true;
    if (top < margin) {
      // Not enough space above, show below
      top = mousePosition.dy + 40; // Below the GIF
      showAbove = false;
    }
    
    // Check if showing below would go off bottom of screen
    if (!showAbove && (top + tooltipHeight > screenSize.height - margin)) {
      // If both above and below don't fit, prioritize above and allow scrolling
      top = mousePosition.dy - tooltipHeight - arrowSize - 10;
      showAbove = true;
      // Ensure it doesn't go above screen
      if (top < margin) {
        top = margin;
      }
    }

    // Determine if we should show left or right aligned
    bool showLeft = false;
    
    // Adjust horizontal position
    if (left < margin) {
      // Too far left, align to left edge
      left = margin;
    } else if (left + tooltipWidth > screenSize.width - margin) {
      // Too far right, try showing to the left of cursor
      left = mousePosition.dx - tooltipWidth - 10;
      showLeft = true;
      
      // If left position still doesn't fit, align to right edge
      if (left < margin) {
        left = screenSize.width - tooltipWidth - margin;
        showLeft = false;
      }
    }

    return Positioned(
      left: left,
      top: top,
      child: Material(
        elevation: 24,
        borderRadius: BorderRadius.circular(12),
        shadowColor: Colors.cyan.withOpacity(0.8),
        child: Container(
          width: tooltipWidth,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1A1A1A), // Very dark background
                const Color(0xFF0D1117), // Almost black
              ],
            ),
            border: Border.all(
              color: Colors.cyan.withOpacity(0.6),
              width: 2,
            ),
            boxShadow: [
              // Primary glow effect
              BoxShadow(
                color: Colors.cyan.withOpacity(0.4),
                blurRadius: 25,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
              // Secondary depth shadow
              BoxShadow(
                color: Colors.black.withOpacity(0.8),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
              // Inner highlight
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: 1,
                spreadRadius: 0,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with grid number and status
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF00E5FF), // Bright cyan
                          Color(0xFF0091EA), // Deep blue
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '#$gridNumber',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (isUserSubmitted)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF00E676), // Bright green
                            Color(0xFF00C853), // Deep green
                          ],
                        ),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Text(
                        'USER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const Spacer(),
                  // Pulsing tech indicator
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.8),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Business name with strong contrast
              Text(
                displayBusinessName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                  height: 1.2,
                  shadows: [
                    Shadow(
                      color: Colors.cyan,
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                    Shadow(
                      color: Colors.black,
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              // GIF name with better contrast
              const SizedBox(height: 8),
              Text(
                displayGifName,
                style: const TextStyle(
                  color: Color(0xFFE0E0E0), // Light gray
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.2,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 1,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              // Description with high contrast
              const SizedBox(height: 10),
              Text(
                displayDescription,
                style: const TextStyle(
                  color: Color(0xFFBDBDBD), // Medium gray
                  fontSize: 12,
                  height: 1.4,
                  letterSpacing: 0.1,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 1,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              // Website URL with enhanced visibility
              if (displayWebsiteUrl != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.cyan.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Colors.cyan.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.cyan.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.language,
                          size: 14,
                          color: Colors.cyan,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          displayWebsiteUrl,
                          style: const TextStyle(
                            color: Colors.cyan,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.cyan,
                            letterSpacing: 0.1,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 1,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}