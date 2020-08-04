import 'package:client/screens/settings_screen.dart';
import 'package:client/utils/constants.dart';
import 'package:flutter/material.dart';

class DrawerCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              children: <Widget>[
                Text(
                  Constants.appName,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  "https://github.com/yesmey/mpv-controller/",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
        ],
      ),
    );
  }
}
