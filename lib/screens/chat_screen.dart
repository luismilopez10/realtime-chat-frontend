import 'package:flutter/material.dart';

import 'package:realtime_chat/app_colors.dart';
import 'package:realtime_chat/models/user.dart';
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

  final List<ChatMessage> _messages = [
    const ChatMessage(userId: '1', text: 'Hola, buenas tardes'),
    const ChatMessage(userId: '2', text: 'Hola'),
    const ChatMessage(userId: '1', text: 'Cómo vas?'),
    const ChatMessage(userId: '2', text: 'Bn bn y tú?'),
    const ChatMessage(userId: '1', text: 'Muy bien'),
    const ChatMessage(
        userId: '1',
        text:
            'Oye sabes cómo puedo poner un texto muy muy largo en una caja de Text?'),
    const ChatMessage(userId: '2', text: 'Mmmm toca mirar'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.instance.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.instance.greyDark,
        elevation: 1,
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.instance.textColor,
              ),
            ),
            CircleAvatar(
              maxRadius: 18.0,
              child: Text(
                widget.user.name.substring(0, 2),
                style: const TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Text(
              widget.user.name,
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
                      itemBuilder: (_, i) => Column(
                        children: [
                          if (i > 0 &&
                              _messages[i - 1].userId != _messages[1].userId)
                            const SizedBox(height: 8.0),
                          _messages[i],
                        ],
                      ),
                      reverse: true,
                    ),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  child: _inputChat(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
              decoration: BoxDecoration(
                color: AppColors.instance.greyDark,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (_) {
                  setState(() {});
                },
                cursorColor: AppColors.instance.greenLight,
                style: TextStyle(color: AppColors.instance.textColor),
                decoration: const InputDecoration.collapsed(
                  hintText: 'Mensaje',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                focusNode: _focusNode,
              ),
            ),
          ),
          const SizedBox(width: 6.0),
          GestureDetector(
            onTap: _textController.text.isNotEmpty
                ? () {
                    _handleSubmit(_textController.text);
                  }
                : null,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              decoration: BoxDecoration(
                color: _textController.text.isNotEmpty
                    ? AppColors.instance.greenLight
                    : Colors.grey,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Icon(
                Icons.send_rounded,
                color: _textController.text.isNotEmpty
                    ? Colors.black
                    : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmit(String text) {
    if (text.isEmpty) {
      _focusNode.requestFocus();
      return;
    }

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(userId: '1', text: text);
    _messages.insert(0, newMessage);

    setState(() {});
  }
}
