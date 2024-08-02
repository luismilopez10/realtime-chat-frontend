import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:emoji_regex/emoji_regex.dart';

import 'package:realtime_chat/app_colors.dart';
import 'package:realtime_chat/services/auth_service.dart';

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
    final authService = Provider.of<AuthService>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1.0),
      child: userId == authService.user.uid
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

  bool _isOnlyEmojis(String text) {
    final emojiRegExp = emojiRegex();
    final emojiMatches = emojiRegExp.allMatches(text);
    return emojiMatches.length == text.runes.length;
  }

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
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.instance.textColor,
              fontSize: _getTextFontSize(text),
            ),
          ),
          // _HourAndCheck(isMyMessage: isMyMessage),
        ),
      ),
    );
  }

  double _getTextFontSize(String text) {
    if (!_isOnlyEmojis(text)) {
      return 15.0;
    }

    switch (text.runes.length) {
      case 1:
        return 32.0;
      case 2:
        return 22.0;
      case 3:
        return 20.0;
      default:
        return 17.0;
    }
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
                fontSize: 12.0,
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
