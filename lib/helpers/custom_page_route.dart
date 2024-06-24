import 'package:flutter/material.dart';

enum CustomDirection {
  toRight,
  toLeft,
}

class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final CustomDirection direction;

  CustomPageRoute({
    required this.page,
    required this.direction,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final begin = direction == CustomDirection.toRight
                ? const Offset(1.0, 0.0)
                : const Offset(-1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}
