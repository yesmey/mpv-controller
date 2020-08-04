import 'package:client/models/config.dart';
import 'package:client/utils/websocket_client.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String shaderValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Navigator Drawer"),
      ),
      body: Center(
        child: StreamBuilder<Config>(
          stream: WebsocketClient.of(context).configBroadcast.stream,
          builder: (context, message) {
            if (!message.hasData) return Container();
            var config = message.data;
            return DropdownButton<String>(
              value: config.shaders.first,
              items:
                  config.shaders.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String newValue) {
                setState(() {
                  shaderValue = newValue;
                });
              },
            );
          },
        ),
      ),
    );
  }
}
