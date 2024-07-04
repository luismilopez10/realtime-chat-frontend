import 'package:flutter/material.dart';

class ConnectionStatusIcon extends StatelessWidget {
  const ConnectionStatusIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const iconsSize = 28.0;

    return const Padding(
      padding: EdgeInsets.only(right: 14.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.electric_bolt,
            size: iconsSize * 0.6,
            color: true ? Colors.green : Colors.red,
          ),
          Icon(
            true ? Icons.circle_outlined : Icons.do_not_disturb,
            size: iconsSize,
            color: true ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }
}
