import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:realtime_chat/services/socket_service.dart';

class ConnectionStatusIcon extends StatelessWidget {
  const ConnectionStatusIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final serverStatus = Provider.of<SocketService>(context).serverStatus;
    const iconsSize = 28.0;

    return Padding(
      padding: const EdgeInsets.only(right: 14.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.electric_bolt,
            size: iconsSize * 0.6,
            color:
                serverStatus == ServerStatus.Online ? Colors.green : Colors.red,
          ),
          Icon(
            serverStatus == ServerStatus.Online
                ? Icons.circle_outlined
                : Icons.do_not_disturb,
            size: iconsSize,
            color:
                serverStatus == ServerStatus.Online ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }
}
