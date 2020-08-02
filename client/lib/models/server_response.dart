import 'dart:convert';

class ServerResponse {
  final String type;
  final String title;
  final dynamic data;

  ServerResponse({this.type, this.title, this.data});

  factory ServerResponse.fromJson(String json) {
    final parsed = jsonDecode(json);
    return ServerResponse(
      type: parsed["type"] as String,
      title: parsed["title"] as String,
      data: parsed["data"],
    );
  }
}
