import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { OnLine, OffLine, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  Function get emit => this._socket.emit;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    // Dart client
    this._socket = IO.io('http://localhost:3000/', {
      'transports': ['websocket'],
      'autoConnect': true
    });

    this._socket.on('connect', (_) {
      _serverStatus = ServerStatus.OnLine;
      notifyListeners();
    });

    this._socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.OffLine;
      notifyListeners();
    });

    // socket.on('nuevo-mensaje', (payload) {
    //   print('Nuevo mensaje');
    //   print('nombre: ' + payload['nombre']);
    //   print('mensaje: ' + payload['mensaje']);
    //   print(payload.containsKey('mensaje2')
    //       ? payload['mensaje2']
    //       : 'no hay data');
    // });
  }
}
