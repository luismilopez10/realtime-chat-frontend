import 'package:flutter/material.dart';
import 'package:realtime_chat/helpers/custom_page_route.dart';

class Labels extends StatelessWidget {
  final Widget page;
  final String title;
  final String subtitle;
  final CustomDirection navigationDirection;

  const Labels({
    super.key,
    required this.page,
    required this.title,
    required this.subtitle,
    required this.navigationDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 15.0,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 10.0),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              CustomPageRoute(
                page: page,
                direction: navigationDirection,
              ),
            );
          },
          child: Text(
            subtitle,
            style: TextStyle(
              color: Colors.blue[600],
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
