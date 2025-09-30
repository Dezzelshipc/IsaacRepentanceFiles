import re
import requests
from collections import defaultdict
from io import StringIO
import xml.etree.ElementTree as ET

_root_url = "https://raw.githubusercontent.com/Dezzelshipc/IsaacRepentanceFiles/refs/heads"

reb_url = f"{_root_url}/v1.05-Hotfix/resources"
ab_url = f"{_root_url}/v1.06.0109/resources"
ab_plus_url = f"{_root_url}/v1.06.J168/resources"
rep_url = f"{_root_url}/v1.7.9b/resources-dlc3"
rep_plus_url = f"{_root_url}/main/resources"

url_dict = {
    "reb": reb_url,
    "ab": ab_url,
    "abp": ab_plus_url,
    "r": rep_url,
    "rp": rep_plus_url,
}


def fix_lua_indent(text: str) -> str:
    depth = 0
    text_out = []
    with StringIO(text) as fs:
        for line in fs.readlines():
            l = line.strip()
            l = re.sub(r'\s+', ' ', l)

            if '}' in l:
                depth -= 1

            add_depth = '{' in l and '}' in l
            text_out.append(f"{"\t" * (depth + add_depth)}{l}\n")

            if '{' in l:
                depth += 1

    return "".join(text_out)


def recursive_dict():
    return defaultdict(recursive_dict)


def get_mult_root(main_url: str, path: str):
    rep_plus_info_url = main_url + path
    rep_plus_info = requests.get(rep_plus_info_url)
    assert rep_plus_info.status_code == 200
    return ET.fromstring(f"<roots>{rep_plus_info.text}</roots>")


def get_single_root(main_url: str, path: str):
    mult = get_mult_root(main_url, path)

    for child in mult:
        return child
    return None


def get_single_root_strict(main_url: str, path: str):
    rep_plus_info_url = main_url + path
    rep_plus_info = requests.get(rep_plus_info_url)
    assert rep_plus_info.status_code == 200
    return ET.fromstring(rep_plus_info.text)
