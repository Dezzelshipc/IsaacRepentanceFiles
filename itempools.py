import xml.etree.ElementTree as ET

import requests
from slpp import slpp as lua

from utility import url_dict, fix_lua_indent, recursive_dict

dlc_order = dict(zip(url_dict.keys(), range(len(url_dict.keys()))))


def get_item_weight(attrib, is_both=False):
    _id = int(attrib["Id"])
    _weight = float(attrib['Weight'])

    return (_weight != 1.0 or is_both) and (_id, _weight < 1 and _weight or int(_weight)) or (_id,)


def get_itempools(is_dict=False):
    weights = set()
    result = recursive_dict()

    for dlc, url in url_dict.items():
        print("Loading", dlc)
        itempools_url = url + "/itempools.xml"
        itempools = requests.get(itempools_url)
        assert itempools.status_code == 200
        ItemPools = ET.fromstring(itempools.text)

        for Pool in ItemPools:
            pool = Pool.attrib["Name"]

            result[pool][dlc] = list(sorted(get_item_weight(Item.attrib, is_dict) for Item in Pool))
            weights = weights.union(map(lambda x: len(x) > 1 and x[1] or 1.0, result[pool][dlc]))

            if is_dict:
                result[pool][dlc] = dict(result[pool][dlc])

    with open("itempools_out.lua", "w") as f:
        f.write(fix_lua_indent(lua.encode(result)))

    print(list(sorted(weights)))


def get_listed_pools():
    with open("itempools_out.lua", "r") as f:
        itempools = lua.decode(f.read())

    result_pool_id = recursive_dict()
    result_id_pool = recursive_dict()

    for itempool, dlc_pools in itempools.items():
        items_set = list(sorted({_id for items in dlc_pools.values() for _id in items.keys()}))

        for _id in items_set:
            weights = [dlc_pools.get(dlc, {}).get(_id, 0) for dlc in dlc_order.keys()]
            result_pool_id[itempool][_id] = weights
            result_id_pool[_id][itempool] = weights

    with open("itempools_pool_id_out.lua", "w") as f:
        f.write(fix_lua_indent(lua.encode(result_pool_id)))

    result_id_pool = dict(sorted(result_id_pool.items()))
    with open("itempools_id_pool_out.lua", "w") as f:
        f.write(fix_lua_indent(lua.encode(result_id_pool)))


if __name__ == "__main__":
    IS_DICT = True
    get_itempools(IS_DICT)

    if IS_DICT:
        get_listed_pools()
