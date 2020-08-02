import 'package:client/models/server_command.dart';
import 'package:client/screens/video_screen.dart';
import 'package:client/utils/websocket_client.dart';
import 'package:flutter/material.dart';
import 'package:client/models/file.dart';

class FileListWidget extends StatelessWidget {
  final FileList fileList;

  FileListWidget(this.fileList);

  @override
  Widget build(BuildContext context) {
    final alignment = Align(
      alignment: Alignment.centerRight,
      child: Container(
        height: 1,
        color: Theme.of(context).dividerColor,
        width: MediaQuery.of(context).size.width - 70,
      ),
    );

    final headerText = Center(
      child: Text(
        "FILES",
        style: Theme.of(context).textTheme.headline1,
      ),
    );

    final subText = Center(
      child: Text(
        fileList.title,
        overflow: TextOverflow.fade,
        softWrap: false,
        maxLines: 1,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );

    return new ListView(
      children: [
        alignment,
        const SizedBox(height: 20),
        headerText,
        subText,
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: fileList.files.length,
            itemBuilder: (BuildContext context, int index) {
              final File file = fileList.files[index];
              return ListTile(
                onTap: () {
                  if (!file.isFolder) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VideoScreen(file: file),
                    ));
                    return;
                  }

                  WebsocketClient.of(context).sendAction(ServerCommand(
                    action: "pick_file",
                    data: file.path,
                  ));
                },
                contentPadding: const EdgeInsets.all(0),
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    file.title == ".."
                        ? Icons.folder_open
                        : (file.title.length == 1
                            ? Icons.disc_full
                            : (file.isFolder
                                ? Icons.folder
                                : Icons.local_movies)),
                    size: 20,
                    color: file.isFolder ? Colors.yellow : Colors.green[300],
                  ),
                ),
                title: Text(
                  "${file.title}",
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                height: 1,
                color: Theme.of(context).dividerColor,
              );
            }),
      ],
    );
  }
}
