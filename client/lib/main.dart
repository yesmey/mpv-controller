import 'package:client/utils/websocket_client.dart';
import 'package:flutter/material.dart';
import 'package:client/screens/main_screen.dart';
import 'package:client/utils/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var client = WebsocketClient(
      child: MaterialApp(
        title: Constants.appName,
        theme: Constants.darkTheme,
        debugShowCheckedModeBanner: false,
        home: MainScreen(),
      ),
    );

    client.service.connect();
    return client;
  }
}
