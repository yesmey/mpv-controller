import 'package:client/models/server_response.dart';
import 'package:flutter/material.dart';

class Config {
  final Map<String, String> options;
  final List<String> shaders;

  Config({@required this.options, @required this.shaders});

  factory Config.fromServerResponse(ServerResponse response) {
    return Config(
      options: Map<String, String>.from(response.data["options"]),
      shaders: List<String>.from(response.data["shaders"], growable: false),
    );
  }
}
