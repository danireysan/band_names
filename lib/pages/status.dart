import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'The status is: ${socketService.serverStatus}',
              style: const TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          log('button pressed');
          socketService.emit(
            'emit-message',
            {'name': 'Flutter', 'message': 'hi from flutter'},
          );
        },
        elevation: 1,
        child: const Icon(Icons.message),
      ),
    );
  }
}
