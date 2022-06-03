import subprocess, sys, os, glob, time
import typing as T

language_mapping = {
    "eng": "English",
    "ja": "Japanese",
    "jp": "Japanese",
    "jap": "Japanese",
    "jpn": "Japanese",
}

def extract_audio(file: str, tracks: T.Any) -> None:
    audio_track = next(track for track in tracks if track["type"] == "audio")
    if not audio_track:
        return

    ext = audio_track["codec"]
    lang = language_mapping[audio_track["language"]]
    id = str(audio_track["id"])
    subprocess.call(['mkvextract', 'tracks', file, id + ':' + lang + '.' + ext])
