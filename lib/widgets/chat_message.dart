import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';

import 'package:realtime_chat/app_colors.dart';
import 'package:realtime_chat/models/messages_response.dart';
import 'package:realtime_chat/providers/chat_settings_provider.dart';
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

  _TextMetrics _getLastLineWidth(
      String text, TextStyle style, double maxWidth) {
    // Crear un TextPainter para medir el texto
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
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
    final chatSettingsProvider = Provider.of<ChatSettingsProvider>(context);

    final screenSize = MediaQuery.sizeOf(context);
    final maxBubbleWidth = screenSize.width * 0.8;

    final formattedTimeText = _getFormattedTime(message.createdAt!);

    //* -TextStyles- MessageText y MessageTime
    final messageTextStyle = TextStyle(
      color: AppColors.instance.textColor,
      fontSize: chatSettingsProvider.getTextFontSize(message.message!),
    );
    final messageTimeStyle = TextStyle(
      color: AppColors.instance.messageTimeTextColor,
      fontSize: 14.0,
    );

    //* Tamaños de los textos
    final timeWidth =
        _getLastLineWidth(formattedTimeText, messageTimeStyle, double.infinity);
    final textLastLineWidth = _getLastLineWidth(
        message.message!, messageTextStyle, maxBubbleWidth - 30.0);

    //* Total de ancho
    final totalLastLineWidth =
        (textLastLineWidth.textSize.width + timeWidth.textSize.width);

    //* Solapamiento de textos
    final double messageTextRightPadding;
    final double messageTextBottomPadding;

    switch (textLastLineWidth.totalLines) {
      case 1:
        if (totalLastLineWidth > maxBubbleWidth) {
          messageTextRightPadding = 10.0;
          messageTextBottomPadding = 24.0;
        } else {
          messageTextRightPadding = timeWidth.textSize.width + 20.0;
          messageTextBottomPadding = 7.0;
        }
        break;
      default:
        messageTextRightPadding = 10.0;
        if (totalLastLineWidth > maxBubbleWidth) {
          messageTextBottomPadding = 24.0;
        } else {
          messageTextBottomPadding = 7.0;
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
                right: messageTextRightPadding,
                top: 4.0,
                bottom: messageTextBottomPadding,
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
                text: formattedTimeText,
                isMyMessage: isMyMessage,
                fontSize: messageTimeStyle.fontSize!,
                constraints: BoxConstraints(
                  minWidth: timeWidth.textSize.width,
                  maxWidth: timeWidth.textSize.width + 5.0, //! ################
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
  final String text;
  final bool isMyMessage;
  final double fontSize;
  final BoxConstraints constraints;

  const _HourAndCheck({
    required this.text,
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
            text,
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
