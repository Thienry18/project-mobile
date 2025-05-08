import 'dart:async';
import 'package:flutter/material.dart';

Widget autoSlideImage({
  required List<String> images,
  double height = 188,
  double borderRadius = 12,
  Duration duration = const Duration(seconds: 3),
}) {
  return _AutoSlideImageWidget(
    images: images,
    height: height,
    borderRadius: borderRadius,
    duration: duration,
  );
}

class _AutoSlideImageWidget extends StatefulWidget {
  final List<String> images;
  final double height;
  final double borderRadius;
  final Duration duration;

  const _AutoSlideImageWidget({
    required this.images,
    required this.height,
    required this.borderRadius,
    required this.duration,
  });

  @override
  State<_AutoSlideImageWidget> createState() => _AutoSlideImageWidgetState();
}

class _AutoSlideImageWidgetState extends State<_AutoSlideImageWidget> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSwitch();
  }

  void _startAutoSwitch() {
    _timer = Timer.periodic(widget.duration, (_) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.images.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(
        milliseconds: 800,
      ), // Durasi lebih lama agar transisi lebih smooth
      transitionBuilder: (Widget child, Animation<double> animation) {
        final fadeAnimation = Tween<double>(
          begin: 0, // gambar mulai hilang
          end: 1, // gambar muncul sepenuhnya
        ).animate(animation);

        return FadeTransition(
          opacity: fadeAnimation, // Fade untuk transisi gambar
          child: child,
        );
      },
      child: ClipRRect(
        key: ValueKey<String>(widget.images[_currentIndex]),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Image.asset(
          widget.images[_currentIndex],
          height: widget.height,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
