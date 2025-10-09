import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

/// Reusable animated rotating title widget.
class AnimatedRotatingTitle extends StatefulWidget {
  final List<String> titles;
  final TextStyle? textStyle;
  final Duration interval;

  const AnimatedRotatingTitle({
    super.key,
    required this.titles,
    this.textStyle,
    this.interval = const Duration(seconds: 10),
  });

  @override
  State<AnimatedRotatingTitle> createState() => _AnimatedRotatingTitleState();
}

class _AnimatedRotatingTitleState extends State<AnimatedRotatingTitle>
    with TickerProviderStateMixin {
  late int _index;
  late final AnimationController _animController;
  late final Animation<Offset> _offsetAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _index = 0;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _offsetAnim = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(_animController);
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);

    _animController.forward();

    // Periodic rotation loop
    Future.doWhile(() async {
      await Future.delayed(widget.interval);
      if (!mounted) return false;
      await _animController.reverse();
      if (!mounted) return false;
      setState(() => _index = (_index + 1) % widget.titles.length);
      await _animController.forward();
      return mounted;
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.textStyle ?? AppTextStyles.displayMedium;
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _offsetAnim,
            child: Text(
              widget.titles[_index],
              key: ValueKey<int>(_index),
              style: style,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
