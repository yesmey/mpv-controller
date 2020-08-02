import 'package:client/models/server_command.dart';
import 'package:client/models/file.dart';
import 'package:client/utils/websocket_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/constants.dart';

import 'drawercode.dart';

class ControlButton extends StatelessWidget {
  final VoidCallback _onTap;
  final IconData iconData;

  ControlButton(this.iconData, this._onTap);

  @override
  Widget build(BuildContext context) {
    return new IconButton(
      onPressed: _onTap,
      iconSize: 50.0,
      icon: new Icon(iconData),
      color: Theme.of(context).buttonColor,
      disabledColor: Theme.of(context).disabledColor,
    );
  }
}

class VideoScreen extends StatefulWidget {
  final File file;

  VideoScreen({Key key, @required this.file}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  bool isPaused;
  bool isPlaying;
  String movieTitle;
  double currentSliderValue = 100;
  double actualVolume = 100;
  double percentPos = 0.0;
  int chapter = 0;
  int chapterCount = 0;

  WebsocketService websocketService;

  void setStateOnMounted(VoidCallback fn) {
    // Because these might be triggered in the background we only want to setState when we are mounted
    if (mounted) {
      setState(fn);
    } else {
      fn();
    }
  }

  @override
  void didChangeDependencies() {
    websocketService = WebsocketClient.of(context);

    websocketService.sendAction(ServerCommand(
      action: "pick_file",
      data: widget.file.path,
    ));

    isPlaying = true;
    isPaused = false;
    movieTitle = widget.file.title;

    websocketService.propertyChangedBroadcast.stream.listen((message) {
      final propertyName = message.data["name"];
      switch (propertyName) {
        case "media-title":
          setStateOnMounted(() {
            movieTitle = message.data["value"] as String ?? "-";
          });
          break;
        case "pause":
          setStateOnMounted(() {
            isPaused = message.data["value"] as bool ?? false;
            isPlaying = !isPaused;
          });
          break;
        case "volume":
          setStateOnMounted(() {
            actualVolume = message.data["value"] as double ?? 0.0;
            if (actualVolume > 0.0) currentSliderValue = actualVolume;
          });
          break;
        case "percent-pos":
          setStateOnMounted(() {
            percentPos = message.data["value"] as double ?? 0.0;
            if (percentPos > 0.0) percentPos /= 100.0;
          });
          break;
        case "chapter":
          chapter = message.data["value"] as int ?? 0;
          break;
        case "chapter-list":
          var chapterList = message.data["value"];
          if (chapterList != null) chapterCount = chapterList.length;
          break;
      }
    });

    super.didChangeDependencies();
  }

  final ColorTween volumeColors =
      ColorTween(begin: Colors.green[200], end: Colors.green[900]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${Constants.appName} - Video"),
      ),
      drawer: DrawerCode(),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: new Column(mainAxisSize: MainAxisSize.min, children: [
          new Column(
            children: <Widget>[
              new Text(
                movieTitle,
                style: Theme.of(context).textTheme.headline6,
              ),
              const Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
              )
            ],
          ),
          new Row(mainAxisSize: MainAxisSize.min, children: [
            new ControlButton(Icons.skip_previous,
                canPlayPrevChapter() ? () => prevChapter() : null),
            new ControlButton(Icons.fast_rewind, () => skip(-15)),
            new ControlButton(isPlaying ? Icons.pause : Icons.play_arrow,
                isPlaying ? () => pause() : () => resume()),
            new ControlButton(Icons.fast_forward, () => skip(15)),
            new ControlButton(Icons.skip_next,
                canPlayNextChapter() ? () => nextChapter() : null),
          ]),
          new Container(
            padding: const EdgeInsets.only(top: 50),
          ),
          new Row(mainAxisSize: MainAxisSize.min, children: [
            Text("Volume: ${actualVolume.round().toString()}"),
          ]),
          new Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.volume_mute),
            Slider(
              value: currentSliderValue,
              min: 0,
              max: 100,
              label: "Volume",
              activeColor: volumeColors.lerp(currentSliderValue / 100),
              onChanged: setVolume,
            ),
            const Icon(Icons.volume_up),
          ]),
          new LinearProgressIndicator(
            minHeight: 40,
            value: percentPos,
          ),
          new Row(mainAxisSize: MainAxisSize.min, children: [
            RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Go back!'))
          ]),
          const Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
          )
        ]),
      ),
    );
  }

  bool canPlayNextChapter() => chapter < (chapterCount - 1);

  void nextChapter() {
    if (canPlayNextChapter()) chapter++;
    websocketService.sendAction(ServerCommand(
      action: "chapter",
      data: chapter,
    ));
  }

  bool canPlayPrevChapter() => chapter > 0;

  void prevChapter() {
    if (canPlayPrevChapter()) chapter--;
    websocketService.sendAction(ServerCommand(
      action: "chapter",
      data: chapter,
    ));
  }

  void skip(int i) {
    websocketService.sendAction(ServerCommand(
      action: "seek",
      data: i,
    ));
  }

  void pause() {
    websocketService.sendAction(ServerCommand(action: "pause"));
    setState(() {
      isPlaying = false;
      isPaused = true;
    });
  }

  void resume() {
    websocketService.sendAction(ServerCommand(action: "resume"));
    setState(() {
      isPlaying = true;
      isPaused = false;
    });
  }

  void setVolume(double value) {
    websocketService.sendAction(ServerCommand(
      action: "volume",
      data: value.round(),
    ));
    setState(() {
      currentSliderValue = value;
    });
  }

  @override
  void dispose() {
    websocketService.sendAction(ServerCommand(action: "stop"));
    super.dispose();
  }
}
