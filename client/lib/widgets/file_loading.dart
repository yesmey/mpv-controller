import 'package:flutter/material.dart';

class FileLoading extends StatelessWidget {
  const FileLoading();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: SizedBox(
            child: const CircularProgressIndicator(),
            width: 60,
            height: 60,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text('Waiting for connection...'),
        )
      ],
    );
  }
}
