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
    const ChatMessage(userId: '2', text: 'Mmmm toca mirar'),
    const ChatMessage(
        userId: '1',
        text:
            'Oye sabes cómo puedo poner un texto muy muy largo en una caja de Text?'),
    const ChatMessage(
        userId: '1',
        text: 'Muy bien oqiwj doqiwj doiqj wodij qwod qoiwj doqij wd'),
    const ChatMessage(userId: '2', text: 'Bn bn y tú? qoiwj doqijw doijq wod'),
    const ChatMessage(
        userId: '1', text: 'Cómo vas? woidjq owijd qoiwjd oqiw doq woidj '),
    const ChatMessage(userId: '2', text: 'Hola aoi daoijw daoiwjd awd oaiwjd '),
    const ChatMessage(
        userId: '1', text: 'Hola, buenas tardes oawdh oaiwjd aoiwjd '),
  ];

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
    return Container(
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              decoration: BoxDecoration(
                color: AppColors.instance.textFieldBackgroundColor,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      print('Emojis');
                    },
                    child: Icon(
                      Icons.emoji_emotions_outlined,
                      color: AppColors.instance.greyColor,
                      size: 24.0,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      onSubmitted: _handleSubmit,
                      onChanged: (_) => setState(() {}),
                      cursorColor: AppColors.instance.sendMessageColor,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                        color: AppColors.instance.textColor,
                        fontSize: 17.0,
                      ),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Mensaje',
                        hintStyle: TextStyle(
                          color: AppColors.instance.greyColor,
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(width: 14.0),
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: Icon(
                  //     Icons.attach_file,
                  //     color: AppColors.instance.greyColor,
                  // size: 14.0,
                  //   ),
                  // ),
                  const SizedBox(width: 14.0),
                  GestureDetector(
                    onTap: () {
                      print('Camera');
                    },
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.instance.greyColor,
                      size: 24.0,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                ],
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
                    ? AppColors.instance.sendMessageColor
                    : Colors.grey,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Icon(
                Icons.send_rounded,
                size: 27.0,
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
