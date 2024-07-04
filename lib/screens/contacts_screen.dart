import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:realtime_chat/app_colors.dart';
import 'package:realtime_chat/helpers/custom_page_route.dart';
import 'package:realtime_chat/models/user.dart';
import 'package:realtime_chat/screens/chat_screen.dart';
import 'package:realtime_chat/widgets/widgets.dart';

class ContactsScreen extends StatefulWidget {
  static const String routerName = 'Contacts';

  const ContactsScreen({Key? key}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final List<User> users = [
    User(uid: '1', name: 'María', email: 'maria@test.com', online: true),
    User(uid: '2', name: 'José', email: 'jose@test.com', online: false),
    User(uid: '3', name: 'Steven', email: 'steven@test.com', online: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.instance.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Contacts',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 1,
        backgroundColor: AppColors.instance.greyDark,
        leading: IconButton(
          icon: const Icon(
            Icons.exit_to_app,
            color: Colors.white,
          ),
          onPressed: () {},
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
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}

class _UserListTile extends StatelessWidget {
  const _UserListTile({
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // onTap: () => Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ChatScreen(user: user),
      //   ),
      // ),
      onTap: () => Navigator.of(context).push(
        CustomPageRoute(
          page: ChatScreen(user: user),
          direction: CustomDirection.toRight,
        ),
      ),
      title: Text(
        user.name,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        user.email,
        style: const TextStyle(color: Colors.grey),
      ),
      leading: CircleAvatar(
        child: Text(user.name.substring(0, 2)),
      ),
      trailing: Container(
        width: 10.0,
        height: 10.0,
        decoration: BoxDecoration(
          color: user.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
