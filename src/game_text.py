from slpp import slpp as lua
import re

from utility import get_single_root_strict, rep_plus_url, fix_lua_indent


def getdata() -> dict[str, dict]:
    gameText = get_single_root_strict(rep_plus_url, "/stringtable.sta")
    result = {}
    for category in gameText:
        if category.tag != "languages":
            for key in category:
                name = key.attrib["name"]
                result[name] = {
                    "en": key[0].text or "",
                    "ru": key[4].text or ""
                }
    return result


def luatable() -> str:
    dictionary = getdata()
    text = fix_lua_indent(lua.encode(dictionary))
    text = re.sub(r"\"\s+}", "\" }", text)
    return text


if __name__ == '__main__':
    with open("game_text_out.lua", "w", encoding="utf-8") as f:
        f.write(luatable())
