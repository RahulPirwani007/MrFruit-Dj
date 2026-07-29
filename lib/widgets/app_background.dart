import 'dart:ui';
import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base color
        Container(color: const Color(0xFF17131F)),

        // Top left glow
        Positioned(
          top: -180,
          left: -120,
          child: Container(
            width: 420,
            height: 420,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(123, 44, 191, 0.651),
            ),
          ),
        ),

        // Top right glow
        Positioned(
          top: -100,
          right: -120,
          child: Container(
            width: 250,
            height: 250,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(90, 41, 133, 0.25),
            ),
          ),
        ),

        // Bottom glow
        Positioned(
          bottom: -220,
          left: -100,
          child: Container(
            width: 500,
            height: 500,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(90, 41, 133, 0.40),
            ),
          ),
        ),

        // Blur layer
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 140, sigmaY: 140),
          child: Container(color: Colors.transparent),
        ),

        // Child UI
        child,
      ],
    );
  }
}
