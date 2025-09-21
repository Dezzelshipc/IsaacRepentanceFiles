import xml.etree.ElementTree as ET
from pathlib import Path

import requests
from slpp import slpp as lua

from utility import *


def convert_types(data: dict[str, str]) -> dict[str, str | int | list[int]]:
    def conv(val: str) -> str | int | list[int]:
        if re.fullmatch(r"[\-\d\s,]+", val):
            return list(map(abs, map(int, val.split(","))))
        if val.isnumeric():
            return int(val)
        return val
    return {
        key: conv(val) for key, val in data.items()
    }


if __name__ == '__main__':
    rep_plus_info_url = rep_plus_url + "/info_display.xml"
    rep_plus_info = requests.get(rep_plus_info_url)
    assert rep_plus_info.status_code == 200
    info_root = ET.fromstring(f"<roots>{rep_plus_info.text}</roots>")

    for child in info_root:
        print(child.tag, child, child.attrib)

        entries = {}

        for entry in child:
            _id = int(entry.attrib["id"])
            entries[_id] = [convert_types(e.attrib) for e in entry]

        save_path = Path(__file__).parent / "info_display_out"
        save_path.mkdir(parents=True, exist_ok=True)

        with open(save_path / f"info_display_{child.tag}_out.lua", "w") as f:
            f.write(fix_lua_indent(lua.encode(entries)))
