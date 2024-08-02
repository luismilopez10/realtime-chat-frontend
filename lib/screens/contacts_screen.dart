import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:realtime_chat/app_colors.dart';
import 'package:realtime_chat/helpers/custom_page_route.dart';
import 'package:realtime_chat/models/user.dart';
import 'package:realtime_chat/screens/chat_screen.dart';
import 'package:realtime_chat/screens/login_screen.dart';
import 'package:realtime_chat/services/auth_service.dart';
import 'package:realtime_chat/services/socket_service.dart';
import 'package:realtime_chat/services/users_service.dart';
import 'package:realtime_chat/widgets/widgets.dart';

class ContactsScreen extends StatefulWidget {
  static const String routerName = 'Contacts';

  const ContactsScreen({Key? key}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final usersService = UsersService();
  List<User> users = [];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    _loadUsers();
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      backgroundColor: AppColors.instance.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Contactos',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 1,
        backgroundColor: AppColors.instance.appBarColor,
        leading: IconButton(
          icon: const Icon(
            Icons.exit_to_app,
            color: Colors.white,
          ),
          onPressed: () {
            socketService.disconnect();

            Navigator.of(context).pushReplacement(
              CustomPageRoute(
                page: const LoginScreen(),
                direction: CustomDirection.toLeft,
              ),
            );
            AuthService.deleteToken();
          },
        ),
        actions: const [
          ConnectionStatusIcon(),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _loadUsers,
        header: const WaterDropHeader(
          complete: Icon(
            Icons.check,
            color: Colors.indigo,
          ),
          waterDropColor: Colors.indigo,
        ),
        child: ListView.separated(
            itemBuilder: (_, i) => _UserListTile(user: users[i]),
            separatorBuilder: (_, i) => const SizedBox(),
            itemCount: users.length),
      ),
    );
  }

  void _loadUsers() async {
    users = await usersService.getUsers();
    setState(() {});
    _refreshController.refreshCompleted();
  }
}

class _UserListTile extends StatelessWidget {
  final User user;

  const _UserListTile({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          CustomPageRoute(
            page: ChatScreen(user: user),
            direction: CustomDirection.toRight,
          ),
        );
      },
      title: Text(
        user.name!,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        user.email!,
        style: const TextStyle(color: Colors.grey),
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.grey[400],
        child: const Icon(Icons.person),
      ),
      trailing: Container(
        width: 10.0,
        height: 10.0,
        decoration: BoxDecoration(
          color: user.online! ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
