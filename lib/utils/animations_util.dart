import 'package:flutter/material.dart';

class AnimationUtils {
  static const int transitionSpeed = 500; //ms

  ///
  /// Slide given screen from bottom to top with scaling
  ///
  static Route<T> createBottomToTopRoute<T>(Widget screen) {
    const begin = Offset(0.0, 1.0); // Start from bottom
    const end = Offset(0.0, 0.0); // End at normal position
    return _createAnimatedRoute(screen, begin, end);
  }

  static Route<T> _createAnimatedRoute<T>(
      Widget screen, Offset begin, Offset end) {
    return PageRouteBuilder<T>(
      transitionDuration:
          const Duration(milliseconds: transitionSpeed), // Animation speed
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var slideTween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: Curves.easeOut)); // Ease out for smoother effect

        // Adding scale effect along with slide transition
        var scaleTween = Tween(begin: 0.9, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut));

        var slideAnimation = animation.drive(slideTween);
        var scaleAnimation = animation.drive(scaleTween);

        return ScaleTransition(
          scale: scaleAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        );
      },
    );
  }
}
