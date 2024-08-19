import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:realtime_chat/app_colors.dart';
import 'package:realtime_chat/models/messages_response.dart';
import 'package:realtime_chat/models/user.dart';
import 'package:realtime_chat/services/auth_service.dart';
import 'package:realtime_chat/services/chat_service.dart';
import 'package:realtime_chat/services/socket_service.dart';
import 'package:realtime_chat/widgets/widgets.dart';

class ChatScreen extends StatefulWidget {
  static const String routerName = 'Chat';
  final User user;

  const ChatScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  late SocketService socketService;
  late ChatService chatService;
  late AuthService authService;

  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();

    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);
    chatService = Provider.of<ChatService>(context, listen: false);

    socketService.socket.on('private-message', _listenMessage);

    _loadHistory(widget.user.uid!);
  }

  void _loadHistory(String userId) async {
    List<Message> chat = await chatService.getChat(userId);

    final history = chat.map((message) {
      message.createdAt = message.createdAt!.toLocal();
      message.updatedAt = message.updatedAt!.toLocal();
      return ChatMessage(message: message);
    }).toList();

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _listenMessage(dynamic payload) {
    final receivedMessage = ChatMessage(message: Message.fromJson(payload));

    receivedMessage.message.createdAt =
        receivedMessage.message.createdAt!.toLocal();
    receivedMessage.message.updatedAt =
        receivedMessage.message.updatedAt!.toLocal();

    setState(() {
      _messages.insert(0, receivedMessage);
    });
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();

    socketService.socket
        .off('private-message'); //! Si se sale del chat, deja de escucharlo

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Locale locale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: AppColors.instance.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.instance.appBarColor,
        elevation: 1,
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Row(
          children: [
            IconButton(
              highlightColor: Colors.grey.withOpacity(0.2),
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.instance.textColor,
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.grey[400],
              maxRadius: 18.0,
              child: const Icon(Icons.person),
            ),
            const SizedBox(width: 10.0),
            Text(
              widget.user.name!,
              style: TextStyle(
                color: AppColors.instance.textColor,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            //* Background Image
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Image.asset(
                'assets/whatsapp_background_dark.png',
                fit: BoxFit.cover,
                color: Colors.grey.withOpacity(0.2),
              ),
            ),

            //* Chat
            Column(
              children: [
                Expanded(
                  child: _buildMessageList(locale),
                ),
                _buildInputChat(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildMessageList(Locale locale) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (_, i) {
          bool isLastMessage = i == _messages.length - 1;

          final currentMessage = _messages[i];
          final nextMessage = !isLastMessage ? _messages[i + 1] : null;

          bool isFirstMessage = i == 0;
          bool isNextMessageFromDifferentUser = !isLastMessage &&
              currentMessage.message.from != nextMessage!.message.from;

          final isFirstMessageOfTheDay = isLastMessage
              ? true
              : !_isSameDay(currentMessage.message.createdAt!,
                  nextMessage!.message.createdAt!);

          return Column(
            children: [
              // if (isLastMessage) const SizedBox(height: 8.0),
              if (isFirstMessageOfTheDay)
                _buildDateHeader(currentMessage.message.createdAt!, locale),
              if (isNextMessageFromDifferentUser && !isFirstMessageOfTheDay)
                const SizedBox(height: 8.0),
              _messages[i],
              if (isFirstMessage) const SizedBox(height: 4.0),
            ],
          );
        },
        reverse: true,
      ),
    );
  }

  Widget _buildDateHeader(DateTime date, Locale locale) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.instance.dateHeaderBackgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        child: Text(
          _getMessageDate(date, locale),
          style: TextStyle(
              color: AppColors.instance.dateHeaderTextColor,
              fontSize: 14.0,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  String _getMessageDate(DateTime messageDate, Locale locale) {
    final now = DateTime.now().toLocal();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final aWeekAgo = today.subtract(const Duration(days: 6));

    final wasSentToday = today.year == messageDate.year &&
        today.month == messageDate.month &&
        today.day == messageDate.day;
    final wasSentYesterday = yesterday.year == messageDate.year &&
        yesterday.month == messageDate.month &&
        yesterday.day == messageDate.day;
    final wasSentWithinLastWeek = messageDate.isAfter(aWeekAgo);

    if (wasSentToday) {
      return 'Hoy';
    } else if (wasSentYesterday) {
      return 'Ayer';
    } else if (wasSentWithinLastWeek) {
      String dayOfWeek =
          DateFormat('EEEE', locale.toString()).format(messageDate);
      return dayOfWeek[0].toUpperCase() + dayOfWeek.substring(1);
    }

    return DateFormat('d \'de\' MMMM \'de\' yyyy', locale.toString())
        .format(messageDate);
  }

  Widget _buildInputChat() {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          margin: const EdgeInsets.only(
              left: 6.0, top: 3.0, right: 6.0, bottom: 6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _buildTextField(),
              ),
              const SizedBox(width: 6.0),

              //* Botón de enviar mensaje
              _buildSendButton(),
            ],
          ),
        ),
      ],
    );
  }

  GestureDetector _buildSendButton() {
    return GestureDetector(
      onTap: textController.text.isNotEmpty
          ? () {
              _handleSubmit(textController.text);
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: textController.text.isNotEmpty
              ? AppColors.instance.sendMessageColor
              : Colors.grey,
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Icon(
          Icons.send_rounded,
          size: 25.0,
          color: textController.text.isNotEmpty ? Colors.black : Colors.black54,
        ),
      ),
    );
  }

  Container _buildTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: AppColors.instance.textFieldBackgroundColor,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(width: 10.0),

          //* Caja de texto del mensaje
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0, bottom: 0.0, right: 8.0),
              child: Scrollbar(
                thickness: 3.0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: TextField(
                    maxLines: 6,
                    minLines: 1,
                    controller: textController,
                    focusNode: focusNode,
                    onSubmitted: _handleSubmit,
                    cursorColor: AppColors.instance.sendMessageColor,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (_) => setState(() {}),
                    style: TextStyle(
                      height: 1.25,
                      color: AppColors.instance.textColor,
                      fontSize: 20.0,
                    ),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Mensaje',
                      hintStyle: TextStyle(
                        color: AppColors.instance.deactivatedColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // const SizedBox(width: 14.0),

          //* Botón de Cámara
          // InkWell(
          //   onTap: () {
          //     print('Camera');
          //   },
          //   child: Icon(
          //     Icons.camera_alt_outlined,
          //     color: AppColors.instance.deactivatedColor,
          //     size: 24.0,
          //   ),
          // ),
          // const SizedBox(width: 4.0),
        ],
      ),
    );
  }

  void _handleSubmit(String text) {
    text = text.trimRight();

    if (text.isEmpty) {
      focusNode.requestFocus();
      return;
    }

    textController.clear();
    focusNode.requestFocus();

    final newMessage = ChatMessage(
      message: Message()
        ..from = authService.user.uid
        ..to = widget.user.uid
        ..message = text
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now(),
    );

    _messages.insert(0, newMessage);

    setState(() {});

    socketService.emit('private-message', {
      'from': authService.user.uid,
      'to': widget.user.uid,
      'message': text,
    });
  }
}
