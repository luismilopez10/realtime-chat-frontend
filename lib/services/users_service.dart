import 'package:http/http.dart' as http;

import 'package:realtime_chat/global/environment.dart';
import 'package:realtime_chat/models/user.dart';
import 'package:realtime_chat/models/users_response.dart';
import 'package:realtime_chat/services/auth_service.dart';

class UsersService {
  Future<List<User>> getUsers({int from = 0}) async {
    try {
      final token = await AuthService.getToken();
      final url = Uri.parse('${Environment.apiUrl}/users');
      final resp = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'x-token': token!,
      });

      final usersReponse = usersResponseFromJson(resp.body);

      return usersReponse.users!;
    } catch (e) {
      return [];
    }
  }
}
