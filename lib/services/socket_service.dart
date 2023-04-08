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
    // Dart client config
    io.Socket socket = io.io('http://192.168.100.31:3000/', {
      'transports': ['websocket'],
      'autoConnect': true,
    });
    _onConnect(socket);
    _onDisconnect(socket);
    socket.on('new-message', (payload) {
      log('new message: $payload');
    });
  }

  void _onConnect(io.Socket socket) {
    socket.onConnect((_) {
      log('connect');
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });
  }

  void _onDisconnect(io.Socket socket) {
    socket.onDisconnect((_) {
      log('disconect');
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
  }
}
