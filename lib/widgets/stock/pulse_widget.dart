// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class PulseAnimationWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double maxScale;

  const PulseAnimationWidget({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.maxScale = 1.2,
  }) : super(key: key);

  @override
  _PulseAnimationWidgetState createState() => _PulseAnimationWidgetState();
}

class _PulseAnimationWidgetState extends State<PulseAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.duration,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
