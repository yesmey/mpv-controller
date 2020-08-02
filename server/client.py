import asyncio
import json
import websockets
import explorer
import config
import mpv

from enum import Enum
from typing import AsyncGenerator
from websockets import WebSocketServerProtocol

class PlayerState(Enum):
    NOT_STARTED = 1
    PLAYING = 2
    PAUSED = 3

class Client:
    def __init__(self, ws: WebSocketServerProtocol):
        self.ws = ws
        self.event_queue = asyncio.Queue()
        self.player : mpv.MPV = None
        self.state = PlayerState.NOT_STARTED
        self.mpv_options = config.read_options()
        self.shaders = config.read_shaders()

    def terminate(self) -> None:
        if not self.player:
            return
        try:
            self.player.terminate()
            self.player = None
        except RuntimeError:
            pass

    def stop(self) -> None:
        self.terminate()
        self.state = PlayerState.NOT_STARTED
        self.event_queue = asyncio.Queue()

    def queue_property_changed_message(self, property: str, value: str) -> None:
        message = json.dumps({"type": "property_changed", "data": { "name": property, "value": value }})
        self.event_queue.put_nowait(message)

    async def get_events(self) -> AsyncGenerator[str, None]:
        while True:
            event = await self.event_queue.get()
            yield event

    def play_movie(self, file: str) -> None:
        if self.player:
            self.stop()

        self.player = mpv.MPV(fullscreen = True, **self.mpv_options)
        self.player.play(file)
        self.state = PlayerState.PLAYING

        property_list = [
            "duration",
            "volume",
            "audio",
            "sub",
            "mute",
            "filename",
            "pause",
            "percent-pos",
            "track-list",
            "chapter",
            "chapter-list",
            "media-title"
        ]

        for p in property_list:
            self.player.observe_property(p, self.queue_property_changed_message)

    def set_option(self, name: str, value: str) -> dict:
        self.mpv_options[name] = value
        if self.player:
            self.player[name] = value
        return self.mpv_options

    def get_options(self) -> dict:
        return self.mpv_options

    def get_shaders(self) -> list:
        return self.shaders

    def set_shader(self, value: str) -> None:
        if self.player:
            if value:
                self.player.command("change-list", "glsl-shaders", "set", value)
            else:
                self.player.command("change-list", "glsl-shaders", "clr", "") # important to send an empty string after clr

    def resume(self) -> None:
        if self.player and self.state != PlayerState.PLAYING:
            self.player.pause = False
            self.state = PlayerState.PLAYING

    def pause(self) -> None:
        if self.player and self.state != PlayerState.PAUSED:
            self.player.pause = True
            self.state = PlayerState.PAUSED
    
    def volume(self, value: float) -> None:
        if self.player:
            self.player.volume = value

    def seek(self, secs: float) -> None:
        if self.player:
            self.player.seek(secs)

    def chapter(self, chapter: int) -> None:
        if self.player:
            self.player.chapter = chapter
 