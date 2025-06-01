import 'package:flutter/material.dart';

class AnimatedLoader extends StatefulWidget {
  const AnimatedLoader({super.key});

  @override
  State<AnimatedLoader> createState() => _AnimatedLoaderState();
}

class _AnimatedLoaderState extends State<AnimatedLoader>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Rotation animation
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Scale (pulse) animation
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([_rotationController, _scaleAnimation]),
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Glowing pulsing circle
              Container(
                width: 90 * _scaleAnimation.value,
                height: 90 * _scaleAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple.shade200.withOpacity(0.3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.6),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ],
                ),
              ),

              // Rotating outer ring
              Transform.rotate(
                angle: _rotationController.value * 6.28319,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.purple,
                      width: 4,
                    ),
                  ),
                ),
              ),

              // Center icon with glowing effect
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple,
                ),
                child: const Center(
                  child: Icon(
                    Icons.bolt, // You can change to any icon
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
