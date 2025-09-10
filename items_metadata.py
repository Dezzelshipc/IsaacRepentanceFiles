from collections import OrderedDict
import xml.etree.ElementTree as ET
from slpp import slpp as lua

import requests

from const import *

rep_meta_url = rep_url + "/resources-dlc3/items_metadata.xml"
rep_meta = requests.get(rep_meta_url).text
rep_root = ET.fromstring(rep_meta)

out = OrderedDict()

for child in rep_root:
    tag = child.tag
    attrib = child.attrib
    # print(tag, attrib)
    index = attrib["id"] + child.tag[0]
    out[index] = attrib.copy()

rep_plus_meta_url = rep_plus_url + "/resources/items_metadata.xml"
rep_plus_meta = requests.get(rep_plus_meta_url).text
rep_plus_root = ET.fromstring(rep_plus_meta)

for child in rep_plus_root:
    tag = child.tag
    attrib = child.attrib
    # print(tag, attrib)
    index = attrib["id"] + child.tag[0]
    for key, val in attrib.items():
        if key != "id":
            out[index][key+"_plus"] = val

rep_plus_item_url = rep_plus_url + "/resources/items.xml"
rep_plus_item = requests.get(rep_plus_item_url).text
rep_plus_item_root = ET.fromstring(rep_plus_item)

convert = {
    "passive": "passive",
    "familiar": "passive",
    "active": "active"
}

for child in rep_plus_item_root:
    tag = child.tag
    attrib = child.attrib

    if tag in convert.keys():
        # print(tag, attrib)
        index = attrib["id"] + "i"
        out[index]["type"] = convert[tag]

with open("items_metadata_out.lua", "w") as f:
    f.write(lua.encode(out))