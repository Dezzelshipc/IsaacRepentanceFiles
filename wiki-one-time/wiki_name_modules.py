from slpp import slpp as lua

from utility import fix_lua_indent

if __name__ == "__main__":
    with open("name_in.lua", "r", encoding="utf-8") as f:
        data = lua.decode(f.read())

    for name, vals in data.items():
        vals["id"] = int(vals["id"])

        if vals.get("quality"):
            del vals["quality"]

    if "ID в игре не задействован" in data:
        del data["ID в игре не задействован"]

    with open("name_out.lua", "w", encoding="utf-8") as f:
        f.write(fix_lua_indent(lua.encode(data)))