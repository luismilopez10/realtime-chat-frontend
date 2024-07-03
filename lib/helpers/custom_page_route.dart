import 'package:flutter/material.dart';

enum CustomDirection {
  toRight,
  toLeft,
  toUp,
  toDown,
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
            final Offset begin;
            switch (direction) {
              case CustomDirection.toRight:
                begin = const Offset(1.0, 0.0);
                break;
              case CustomDirection.toLeft:
                begin = const Offset(-1.0, 0.0);
                break;
              case CustomDirection.toUp:
                begin = const Offset(0.0, 1.0);
                break;
              case CustomDirection.toDown:
                begin = const Offset(0.0, -1.0);
                break;
              default:
                begin = const Offset(1.0, 0.0);
            }

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
