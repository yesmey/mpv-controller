# mpv controller :tv:
Control your mpv player remotely from an app. Avaliable for both iOS and Android

## Installation
* Install all [server dependencies](#server-dependencies)
* Place mpv-1.dll from libmpv in your Python38\Scripts folder
  * To find your Scripts folder, you can write the following in your python interpreter:
    ```bash
    python -c "import os; import sys; print(os.path.join(os.path.dirname(sys.executable), 'Scripts'))"
    ```

* For help getting started with Flutter, view the [online documentation](https://flutter.dev/)

## Running
* Start the server with ``` python server.py ```
* Run the app on a mobile device

## Server Dependencies
* [Python 3.8](https://www.python.org/)
* [mpv & libmpv](https://mpv.io/)

## Contact
[yesmey](https://github.com/yesmey)

## License
[Apache 2.0](https://opensource.org/licenses/Apache-2.0)
