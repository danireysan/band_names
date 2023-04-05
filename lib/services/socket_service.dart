import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;

  ServerStatus get serverStatus => _serverStatus;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    // Dart client
    io.Socket socket = io.io('http://192.168.100.31:3000/', {
      'transports': ['websocket'],
      'autoConnect': true,
    });
    socket.onConnect((_) {
      log('connect');
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });
    socket.onDisconnect((_) {
      log('disconect');
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
  }
}
