import 'package:client/screens/drawercode.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/websocket_client.dart';
import 'package:client/widgets/file_list.dart';
import 'package:client/widgets/file_loading.dart';
import 'package:client/widgets/file_error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:client/models/file.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.appName),
      ),
      drawer: DrawerCode(),
      body: Center(
        child: StreamBuilder<FileList>(
          stream: WebsocketClient.of(context).fileListBroadcast.stream,
          builder: (context, message) {
            return parseResponse(message);
          },
        ),
      ),
    );
  }

  Widget parseResponse(AsyncSnapshot<FileList> snapshot) {
    if (snapshot.hasError) {
      return FileError((snapshot.error as Exception).toString());
    }

    if (snapshot.connectionState == ConnectionState.waiting ||
        !snapshot.hasData) {
      return const FileLoading();
    }

    return FileListWidget(snapshot.data);
  }
}
