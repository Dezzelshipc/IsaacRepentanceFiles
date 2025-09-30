import re
from pathlib import Path

from slpp import slpp as lua

from utility import rep_plus_url, fix_lua_indent, get_mult_root


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

def main() -> dict[str, str]:
    info_root = get_mult_root(rep_plus_url, "/info_display.xml")

    result = {}

    for child in info_root:
        entries = {}

        for entry in child:
            _id = int(entry.attrib["id"])
            entries[_id] = [convert_types(e.attrib) for e in entry]

        result[child.tag] = fix_lua_indent(lua.encode(entries))

    return result

if __name__ == '__main__':
    data = main()

    save_path = Path(__file__).parent / "info_display_out"
    save_path.mkdir(parents=True, exist_ok=True)
    for name, entries in data.items():

        with open(save_path / f"info_display_{name}_out.lua", "w") as f:
            f.write(entries)
