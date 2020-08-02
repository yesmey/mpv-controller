import os
import string

from typing import Dict, List

def read_options() -> Dict[str, str]:
    config_path: str = None
    if os.name == 'posix':
        config_path = os.path.expanduser('~/.config/mpv/mpv.conf')
    elif os.name == 'nt':
        config_path = os.path.expandvars('%APPDATA%\\mpv\\mpv.conf')
    else:
        raise NotImplementedError("Invalid OS!")
 
    if not os.path.exists(config_path):
        #could not find config file, skipping
        return dict()

    with open(config_path) as file:
        return dict(stripped.split("=") for line in file.readlines() if not line.startswith("#") and (stripped := line.strip()))

def read_shaders() -> List[str]:
    shaders_path: str = None
    if os.name == 'posix':
        shaders_path = os.path.expanduser('~/.config/mpv/shaders')
    elif os.name == 'nt':
        shaders_path = os.path.expandvars('%APPDATA%\\mpv\\shaders')
    else:
        raise NotImplementedError("Invalid OS!")

    if not os.path.exists(shaders_path):
        #could not find config file, skipping
        return []

    return ["~~/shaders/{0}".format(file) for file in os.listdir(shaders_path)]

#print(read_options())
#print(read_shaders())
