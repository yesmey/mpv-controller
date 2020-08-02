import 'package:client/models/server_response.dart';
import 'package:meta/meta.dart';

class File {
  final String title;
  final String path;
  final bool isFolder;

  File({@required this.title, @required this.path, @required this.isFolder});

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      title: json["title"] as String,
      path: json["path"] as String,
      isFolder: json["isFolder"] as bool,
    );
  }
}

class FileList {
  final String title;
  final List<File> files;

  FileList({@required this.title, @required this.files});

  factory FileList.fromServerResponse(ServerResponse response) {
    return FileList(
      title: response.title,
      files: response.data.map<File>((json) => File.fromJson(json)).toList(),
    );
  }
}
