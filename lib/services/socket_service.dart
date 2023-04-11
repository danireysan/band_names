import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late io.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  io.Socket get socket => _socket;
  Function get emit => _socket.emit;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    // Dart client config
    _socket = io.io('http://192.168.100.31:3000/', {
      'transports': ['websocket'],
      'autoConnect': true,
    });
    _onConnect();
    _onDisconnect();
  }

  void _onConnect() {
    _socket.onConnect((_) {
      log('connect');
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });
  }

  void _onDisconnect() {
    _socket.onDisconnect((_) {
      log('disconect');
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
  }
}
