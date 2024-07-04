import 'package:flutter/material.dart';

import 'package:realtime_chat/app_colors.dart';

class ChatMessage extends StatelessWidget {
  final String userId;
  final String text;

  const ChatMessage({
    super.key,
    required this.userId,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1.0),
      child: userId == '1'
          ? _MessageContainer(
              text: text,
              isMyMessage: true,
            )
          : _MessageContainer(
              text: text,
              isMyMessage: false,
            ),
    );
  }
}

class _MessageContainer extends StatelessWidget {
  final String text;
  final bool isMyMessage;

  const _MessageContainer({
    required this.text,
    required this.isMyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 330.0,
        ),
        decoration: BoxDecoration(
          color: isMyMessage
              ? AppColors.instance.myMessageColor
              : AppColors.instance.notMyMessageColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          child: Text(
            text,
            style: TextStyle(color: AppColors.instance.textColor),
          ),
          // _HourAndCheck(isMyMessage: isMyMessage),
        ),
      ),
    );
  }
}

class _HourAndCheck extends StatelessWidget {
  const _HourAndCheck({
    required this.isMyMessage,
  });

  final bool isMyMessage;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2.0, right: 10.0, left: 2.0),
        child: Row(
          children: [
            Text(
              '6:47 p. m.',
              style: TextStyle(
                color: AppColors.instance.textColor.withOpacity(0.6),
                fontSize: 11.0,
              ),
            ),
            if (isMyMessage)
              const Icon(
                Icons.check,
                color: Colors.grey,
                size: 18.0,
              ),
          ],
        ),
      ),
    );
  }
}
