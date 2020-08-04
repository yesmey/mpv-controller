import os
import sys

from typing import List

def is_folder(path: str) -> bool:
    return os.path.isdir(path)

def get_upper_dir(path: str) -> str:
    try:
        return os.path.dirname(path)
    except:
        return path

def get_name(path: str) -> str:
    return os.path.basename(path)

def is_valid_extension(path: str) -> bool:
    _, file_extension = os.path.splitext(path)
    return file_extension in [
        '.mkv', '.avi', '.mp4', '.ogv', '.webm', '.rmvb', '.flv', '.wmv', '.mpeg', '.mpg', '.m4v',
        '.3gp', '.mp3', '.wav', '.ogm', '.flac', '.m4a', '.wma', '.ogg', '.opus'
    ]

def get_root() -> List[object]:
    return [{ "title": chr(x), "path": chr(x) + ":\\", "isFolder": True } for x in range(65,90) if os.path.exists(chr(x) + ":\\")]

def get_all_files(path: str) -> List[object]:
    if path == "":
        return get_root()

    if not os.path.exists(path):
        return []

    upperDirectory = get_upper_dir(path)
    if not is_folder(upperDirectory):
        return []
    
    if upperDirectory == path:
        upperDirectory = ""

    result = [{ "title": "..", "path": upperDirectory, "isFolder": True }]
    for f in os.listdir(path):
        if not f.startswith('.'):
            filePath = os.path.join(path, f)
            if (isFolder := is_folder(filePath)) or is_valid_extension(f):
                result.append({ "title": f, "path": filePath, "isFolder": isFolder })
    return result

#print(get_root())