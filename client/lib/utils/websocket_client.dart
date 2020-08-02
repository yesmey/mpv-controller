import 'dart:async';

import 'package:client/models/server_command.dart';
import 'package:client/models/config.dart';
import 'package:client/models/file.dart';
import 'package:flutter/material.dart';

import 'package:client/models/server_response.dart';
import 'package:web_socket_channel/io.dart';

class WebsocketClient extends InheritedWidget {
  final WebsocketService service = WebsocketService();

  WebsocketClient({Key key, @required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static WebsocketService of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<WebsocketClient>()
        .service;
  }
}

class WebsocketService {
  IOWebSocketChannel _webSocketChannel;

  final StreamController<ServerResponse> propertyChangedBroadcast =
      StreamController.broadcast();

  final StreamController<Config> configBroadcast = StreamController.broadcast();

  final StreamController<FileList> fileListBroadcast =
      StreamController.broadcast();

  void connect() {
    if (_webSocketChannel != null) {
      return;
    }

    final dest = Uri.parse('ws://192.168.1.202:8765');
    _webSocketChannel = IOWebSocketChannel.connect(dest);
    _webSocketChannel.stream.listen(_processResponse);
  }

  void _processResponse(dynamic jsonData) {
    ServerResponse serverResponse;
    try {
      serverResponse = ServerResponse.fromJson(jsonData);
    } catch (exception) {
      //? errorBroadcast.add(exception);
      return;
    }

    switch (serverResponse.type) {
      case "explorer":
        fileListBroadcast.add(FileList.fromServerResponse(serverResponse));
        break;
      case "config":
        configBroadcast.add(Config.fromServerResponse(serverResponse));
        break;
      case "property_changed":
        propertyChangedBroadcast.add(serverResponse);
        break;
    }
  }

  void sendAction(ServerCommand actionMessage) {
    if (_webSocketChannel != null) {
      _webSocketChannel.sink.add(actionMessage.toJson());
    }
  }
}
