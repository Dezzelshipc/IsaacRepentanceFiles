from collections import OrderedDict
import xml.etree.ElementTree as ET
from slpp import slpp as lua
import requests
from utility import url_dict, fix_lua_indent

if __name__ == "__main__":
    weights = set()
    result = OrderedDict({})

    for dlc, url in url_dict.items():
        print("Loading", dlc)
        itempools_url = url + "/itempools.xml"
        itempools = requests.get(itempools_url)
        assert itempools.status_code == 200
        ItemPools = ET.fromstring(itempools.text)

        for Pool in ItemPools:
            pool = Pool.attrib["Name"]
            if pool not in result:
                result[pool] = OrderedDict({})

            result[pool][dlc] = list(sorted( ( int(Item.attrib["Id"]), float(Item.attrib["Weight"]) ) for Item in Pool))
            weights = weights.union(map(lambda x: x[-1], result[pool][dlc]))

    with open("itempools_out.lua", "w") as f:
        f.write(fix_lua_indent(lua.encode(result)))

    print(weights)