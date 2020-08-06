import argparse
import asyncio
import json
import websockets
import explorer as Explorer

from client import Client
from typing import Dict
from websockets import WebSocketServerProtocol

class Server:
    clients: Dict[WebSocketServerProtocol, Client] = dict()

    def send_files_event(self, message: str) -> str:
        return json.dumps({"type": "explorer", "title": Explorer.get_name(message), "data": Explorer.get_all_files(message)})

    def send_config_event(self, client: Client) -> str:
        return json.dumps({"type": "config", "data": { "options": client.get_options(), "shaders": client.get_shaders() }})

    def register(self, ws: WebSocketServerProtocol) -> None:
        self.clients[ws] = Client(ws)

    def unregister(self, ws: WebSocketServerProtocol) -> None:
        if ws in self.clients:
            self.clients[ws].terminate()
            self.clients.pop(ws)

    async def consumer(self, ws: WebSocketServerProtocol) -> None:
        if ws not in self.clients:
            raise Exception("Websocket missing from clients list. Make sure it has been registered")

        client = self.clients[ws]

        await ws.send(self.send_files_event(""))
        await ws.send(self.send_config_event(client))

        async for message in ws:
            action = None
            data = None
            try:
                json_message = json.loads(message)
                action = json_message["action"]
                data = json_message["data"]
            except:
                print("Could not parse json. Recieved: '" + message + "'")
                break

            if action == "pick_file":
                if Explorer.is_folder(data):
                    await ws.send(self.send_files_event(data))
                elif Explorer.is_valid_extension(data):
                    client.play_movie(data)
                else:
                    await ws.send(self.send_files_event(Explorer.get_upper_dir(data)))
            elif action == "read_config":
                await ws.send(self.send_config_event(client))
            elif action == "pause":
                client.pause()
            elif action == "resume":
                client.resume()
            elif action == "stop":
                client.stop()
            elif action == "volume":
                client.volume(data)
            elif action == "seek":
                client.seek(data)
            elif action == "chapter":
                client.chapter(data)
            elif action == "option":
                option_name = data["name"]
                option_value = data["value"]
                client.set_option(option_name, option_value)
            elif action == "shader":
                client.set_shader(data)

    async def producer(self, ws: WebSocketServerProtocol) -> None:
        client = self.clients[ws]
        async for event in client.get_events():
            await ws.send(event)

    async def ws_handler(self, ws: WebSocketServerProtocol, uri: str) -> None:
        self.register(ws)
        try:
            consumer_task = asyncio.ensure_future(self.consumer(ws))
            producer_task = asyncio.ensure_future(self.producer(ws))
            _, pending = await asyncio.wait([consumer_task, producer_task], return_when=asyncio.FIRST_COMPLETED)
            for task in pending:
                task.cancel()
        finally:
            self.unregister(ws)

if __name__ == '__main__':
    argument_parser = argparse.ArgumentParser(description='mpv-controller server')
    argument_parser.add_argument("-ip", "--ip_address", required=True, default="127.0.0.1", help="IP Address")
    argument_parser.add_argument("-p", "--port", required=True, default=8765, help="Port")
    args = vars(argument_parser.parse_args())

    server = Server()
    start_server = websockets.serve(server.ws_handler, args["ip_address"], args["port"])

    loop = asyncio.get_event_loop()
    loop.run_until_complete(start_server)
    loop.run_forever()
