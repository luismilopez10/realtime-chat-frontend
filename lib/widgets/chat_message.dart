import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';
import 'package:emoji_regex/emoji_regex.dart';

import 'package:realtime_chat/app_colors.dart';
import 'package:realtime_chat/models/messages_response.dart';
import 'package:realtime_chat/services/auth_service.dart';

class ChatMessage extends StatelessWidget {
  final Message message;

  const ChatMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1.0),
      child: message.from == authService.user.uid
          ? _MessageContainer(
              message: message,
              isMyMessage: true,
            )
          : _MessageContainer(
              message: message,
              isMyMessage: false,
            ),
    );
  }
}

class _MessageContainer extends StatelessWidget {
  final Message message;
  final bool isMyMessage;

  const _MessageContainer({
    required this.message,
    required this.isMyMessage,
  });

  double _getTextFontSize(String text) {
    if (!_isOnlyEmojis(text)) {
      return 18.0;
    }

    switch (text.runes.length) {
      case 1:
        return 32.0;
      case 2:
        return 24.0;
      case 3:
        return 22.0;
      default:
        return 19.0;
    }
  }

  Size _getTextSize(String text, TextStyle style, double maxWidth) {
    TextStyle updatedStyle = style.copyWith(fontSize: style.fontSize! + 2);

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: updatedStyle),
      maxLines: null,
      textDirection: ui.TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    return textPainter.size;
  }

  bool _isOnlyEmojis(String text) {
    final emojiRegExp = emojiRegex();
    final emojiMatches = emojiRegExp.allMatches(text);
    return emojiMatches.length == text.runes.length;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final maxBubbleWidth = screenSize.width * 0.8;
    const messageTimeFontSize = 14.0;

    final messageTextStyle = TextStyle(
      color: AppColors.instance.textColor,
      fontSize: _getTextFontSize(message.message!),
    );

    final messageTimeStyle = TextStyle(
      color: AppColors.instance.messageTimeTextColor,
      fontSize: messageTimeFontSize,
    );

    final textSize =
        _getTextSize(message.message!, messageTextStyle, maxBubbleWidth);
    final timeSize = _getTextSize(
      _getFormattedTime(message.createdAt!),
      messageTimeStyle,
      double.infinity,
    );

    final isTextOverlappingTime =
        (textSize.width + timeSize.width) > (maxBubbleWidth - 30.0)
        // && (textSize.width) < (maxBubbleWidth - 1.0)
        // && textSize.width != maxBubbleWidth
        ;

    //* Burbuja que contiene el mensaje
    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxBubbleWidth),
        decoration: BoxDecoration(
          color: isMyMessage
              ? AppColors.instance.myMessageColor
              : AppColors.instance.notMyMessageColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: [
            //* Texto del mensaje
            Padding(
              padding: EdgeInsets.only(
                left: 10.0,
                right: isTextOverlappingTime ? 10.0 : timeSize.width + 10.0,
                top: 4.0,
                bottom: isTextOverlappingTime ? timeSize.height + 7.0 : 7.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxBubbleWidth,
                ),
                child: Text(
                  message.message!,
                  style: messageTextStyle,
                ),
              ),
            ),

            //* Hora del mensaje
            Positioned(
              bottom: 3.0,
              right: 8.0,
              child: _HourAndCheck(
                message: message,
                isMyMessage: isMyMessage,
                fontSize: messageTimeFontSize,
                constraints: BoxConstraints(
                  minWidth: timeSize.width,
                  maxWidth: timeSize.width,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HourAndCheck extends StatelessWidget {
  final Message message;
  final bool isMyMessage;
  final double fontSize;
  final BoxConstraints constraints;

  const _HourAndCheck({
    required this.message,
    required this.isMyMessage,
    required this.fontSize,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: constraints,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            _getFormattedTime(message.createdAt!),
            style: TextStyle(
              color: AppColors.instance.messageTimeTextColor,
              fontSize: fontSize,
            ),
          ),
          // if (isMyMessage)
          //   const Icon(
          //     Icons.check,
          //     color: Colors.grey,
          //     size: 18.0,
          //   ),
        ],
      ),
    );
  }
}

String _getFormattedTime(DateTime dateTime) {
  return DateFormat.jm()
      .format(dateTime)
      .replaceAll('AM', 'a.m.')
      .replaceAll('PM', 'p.m.');
}
