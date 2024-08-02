import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:realtime_chat/global/environment.dart';
import 'package:realtime_chat/models/messages_response.dart';
import 'package:realtime_chat/services/auth_service.dart';

class ChatService with ChangeNotifier {
  Future<List<Message>> getChat(String userId) async {
    final token = await AuthService.getToken();
    final url = Uri.parse('${Environment.apiUrl}/messages/$userId');
    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'x-token': token!,
    });

    final messagesReponse = messagesResponseFromJson(resp.body);

    return messagesReponse.messages!;
  }
}
