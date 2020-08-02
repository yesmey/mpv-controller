import 'package:flutter/material.dart';

class FileError extends StatelessWidget {
  final String errorMessage;
  const FileError(this.errorMessage);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text('Error: $errorMessage'),
        )
      ],
    );
  }
}
