import 'dart:convert';

class ServerCommand {
  final String action;
  final dynamic data;

  ServerCommand({this.action, this.data});

  String toJson() => jsonEncode({
        "action": action,
        "data": data,
      });
}
