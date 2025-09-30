from slpp import slpp as lua

from src.utility import fix_lua_indent, get_single_root, rep_plus_url

if __name__ == "__main__":
    data = {}

    pocketitems = get_single_root(rep_plus_url, "/pocketitems.xml")

    for child in pocketitems:
        if child.tag == "pilleffect":
            _id = int(child.attrib["id"])
            data[_id] = {
                "nameID": child.attrib["name"].replace("#", ""),
            }
            if decs := child.attrib.get_single_root("description"):
                data[_id].update({
                    "descID": decs.replace("#", "")
                })

    with open("name_out.lua", "w", encoding="utf-8") as f:
        f.write(fix_lua_indent(lua.encode(data)))