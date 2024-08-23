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

  bool _isOnlyEmojis(String text) {
    final emojiRegExp = emojiRegex();
    final emojiMatches = emojiRegExp.allMatches(text);

    return emojiMatches.length == text.runes.length;
  }

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

  _TextMetrics _getLastLineWidth(
      String text, TextStyle style, double maxWidth) {
    TextStyle updatedStyle = style.copyWith(fontSize: style.fontSize! + 2.0);

    // Crear un TextPainter para medir el texto
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: updatedStyle),
      maxLines: null,
      textDirection: ui.TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    // Obtener el número total de líneas
    final int totalLines = textPainter.computeLineMetrics().length;

    // Calcular el offset del inicio de la última línea
    final lastLineStartOffset = textPainter.getPositionForOffset(
      Offset(0, (totalLines - 1) * textPainter.preferredLineHeight),
    );

    // Calcular el offset del final de la última línea
    final lastLineEndOffset = textPainter.getPositionForOffset(
      Offset(maxWidth, (totalLines - 1) * textPainter.preferredLineHeight),
    );

    // Calcular el ancho de la última línea
    final lastLineWidth =
        textPainter.getOffsetForCaret(lastLineEndOffset, Rect.zero).dx -
            textPainter.getOffsetForCaret(lastLineStartOffset, Rect.zero).dx;

    return _TextMetrics(
      textSize: Size(lastLineWidth, textPainter.preferredLineHeight),
      totalLines: totalLines,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final maxBubbleWidth = screenSize.width * 0.8;
    const messageTimeFontSize = 14.0;

    //* -TextStyles- MessageText y MessageDate
    final messageTextStyle = TextStyle(
      color: AppColors.instance.textColor,
      fontSize: _getTextFontSize(message.message!),
    );
    final messageTimeStyle = TextStyle(
      color: AppColors.instance.messageTimeTextColor,
      fontSize: messageTimeFontSize,
    );

    //* Tamaños de los textos
    final timeWidth = _getLastLineWidth(
      _getFormattedTime(message.createdAt!),
      messageTimeStyle,
      double.infinity,
    );
    final textLastLineWidth =
        _getLastLineWidth(message.message!, messageTextStyle, maxBubbleWidth);

    //* Total de ancho
    final totalLastLineWidth =
        (textLastLineWidth.textSize.width + timeWidth.textSize.width);

    //* Solapamiento de textos
    final double rightPadding;
    final double bottomPadding;

    switch (textLastLineWidth.totalLines) {
      case 1:
        if (totalLastLineWidth > maxBubbleWidth) {
          rightPadding = 10.0;
          bottomPadding = 24.0;
        } else {
          rightPadding = timeWidth.textSize.width + 10.0;
          bottomPadding = 7.0;
        }
        break;
      default:
        rightPadding = 10.0;
        if (totalLastLineWidth > maxBubbleWidth) {
          bottomPadding = 24.0;
        } else {
          bottomPadding = 7.0;
        }
    }

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
                right: rightPadding,
                top: 4.0,
                bottom: bottomPadding,
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
                  minWidth: timeWidth.textSize.width,
                  maxWidth: timeWidth.textSize.width,
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

class _TextMetrics {
  final Size textSize;
  final int totalLines;

  _TextMetrics({
    required this.textSize,
    required this.totalLines,
  });
}
