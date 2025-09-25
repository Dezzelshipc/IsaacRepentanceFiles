from slpp import slpp as lua

from utility import fix_lua_indent, get_single_root, rep_plus_url

if __name__ == "__main__":
    with open("name_in.lua", "r", encoding="utf-8") as f:
        data = lua.decode(f.read())

    pocketitems = get_single_root(rep_plus_url, "/pocketitems.xml")

    for name, vals in data.items():
        _id = int(vals.get_single_root("id", -1))

        for child in pocketitems:
            if child.tag != "pilleffect" and int(child.attrib["id"]) == _id:
                vals["nameID"] = child.attrib["name"]
                vals["descID"] = child.attrib["description"]

    with open("name_out.lua", "w", encoding="utf-8") as f:
        f.write(fix_lua_indent(lua.encode(data)))