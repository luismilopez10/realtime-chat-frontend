import 'package:flutter/material.dart';
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
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late SocketService socketService;
  late ChatService chatService;
  late AuthService authService;

  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);
    chatService = Provider.of<ChatService>(context, listen: false);

    socketService.socket.on('private-message', _listenMessage);

    _loadHistory(widget.user.uid!);

    super.initState();
  }

  void _loadHistory(String userId) async {
    List<Message> chat = await chatService.getChat(userId);

    final history = chat.map((message) => ChatMessage(
          userId: message.from!,
          text: message.message!,
        ));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _listenMessage(dynamic payload) {
    final receivedMessage = ChatMessage(
      userId: payload['from'],
      text: payload['message'],
    );

    setState(() {
      _messages.insert(0, receivedMessage);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();

    socketService.socket
        .off('private-message'); //! Si se sale del chat, deja de escucharlo

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {
                Navigator.pop(context);
              },
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
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Image.asset(
                'assets/whatsapp_background_dark.png',
                fit: BoxFit.cover,
                color: Colors.grey.withOpacity(0.2),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (_, i) {
                        bool isFirstMessage = i == 0;
                        bool isLastMessage = i == _messages.length - 1;
                        bool isNextMessageFromDifferentUser =
                            i < _messages.length - 1 &&
                                _messages[i].userId != _messages[i + 1].userId;

                        return Column(
                          children: [
                            if (isLastMessage || isNextMessageFromDifferentUser)
                              const SizedBox(height: 8.0),
                            _messages[i],
                            if (isFirstMessage) const SizedBox(height: 8.0),
                          ],
                        );
                      },
                      reverse: true,
                    ),
                  ),
                ),
                _inputChat(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: AppColors.instance.textFieldBackgroundColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(width: 10.0),

                      //* Caja de texto del mensaje
                      Expanded(
                        child: Scrollbar(
                          thickness: 2.5,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: TextField(
                              maxLines: 6,
                              minLines: 1,
                              controller: _textController,
                              focusNode: _focusNode,
                              onSubmitted: _handleSubmit,
                              cursorColor: AppColors.instance.sendMessageColor,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              onChanged: (_) => setState(() {}),
                              style: TextStyle(
                                height: 1.25,
                                color: AppColors.instance.textColor,
                                fontSize: 17.0,
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
                      const SizedBox(width: 14.0),

                      //* Botón de Cámara
                      InkWell(
                        onTap: () {
                          print('Camera');
                        },
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.instance.deactivatedColor,
                          size: 24.0,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6.0),

              //* Botón de enviar mensaje
              GestureDetector(
                onTap: _textController.text.isNotEmpty
                    ? () {
                        _handleSubmit(_textController.text);
                      }
                    : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: _textController.text.isNotEmpty
                        ? AppColors.instance.sendMessageColor
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Icon(
                    Icons.send_rounded,
                    size: 25.0,
                    color: _textController.text.isNotEmpty
                        ? Colors.black
                        : Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleSubmit(String text) {
    text = text.trimRight();

    if (text.isEmpty) {
      _focusNode.requestFocus();
      return;
    }

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      userId: authService.user.uid!,
      text: text,
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
