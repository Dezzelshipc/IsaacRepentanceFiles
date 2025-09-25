from collections import OrderedDict

from slpp import slpp as lua

from utility import url_dict, recursive_dict, fix_lua_indent, get_single_root


def get_qt_dict(tag, attrib):
    qt_dict = OrderedDict()
    if tag in ["items"] and "quality" in attrib:
        qt_dict["quality"] = int(attrib["quality"])
    if "craftquality" in attrib:
        qt_dict["craftquality"] = int(attrib["craftquality"])
    qt_dict["tags"] = attrib["tags"]

    return qt_dict


def add_metadata(res, dlc, url):
    if dlc in list(url_dict.keys())[-2:]:
        print("Loading", dlc, "items_metadata.xml")

        items_root = get_single_root(url, "/items_metadata.xml")

        for item in items_root:
            tag = item.tag + "s"
            attrib = item.attrib

            index = int(attrib["id"])
            res[tag][index][dlc].update(get_qt_dict(tag, attrib))


convert_types = {
    "passive": "passive",
    "familiar": "passive",
    "active": "active"
}


def add_items_data(res, dlc, url):
    print("Loading", dlc, "items.xml")

    items_root = get_single_root(url, "/items.xml")

    for item in items_root:
        tag = item.tag
        attrib = item.attrib

        if tag in convert_types.keys() and "gfx" in attrib:
            index = int(attrib["id"])

            res["items"][index]["type"] = convert_types[tag]

            if (devilprice := attrib.get("devilprice")) and int(devilprice) > 1:
                res["items"][index][dlc]["devilprice"] = int(devilprice)


if __name__ == "__main__":
    result = recursive_dict()

    for dlc_, url_ in url_dict.items():
        add_items_data(result, dlc_, url_)

        add_metadata(result, dlc_, url_)

    with open("items_metadata_out.lua", "w") as f:
        f.write(fix_lua_indent(lua.encode(result)))
