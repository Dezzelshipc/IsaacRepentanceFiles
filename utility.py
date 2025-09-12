import re
from io import StringIO

_root_url = "https://raw.githubusercontent.com/Dezzelshipc/IsaacRepentanceFiles/refs/heads"

reb_url =       "%s/v1.05-Hotfix" % _root_url
ab_url =        "%s/v1.06.0109" % _root_url
ab_plus_url =   "%s/v1.06.J168" % _root_url
rep_url =       "%s/v1.7.9b" % _root_url
rep_plus_url =  "%s/main" % _root_url


def fix_lua_indent(text: str) -> str:
    depth = 0
    text_out = []
    with StringIO(text) as fs:
        for line in fs.readlines():
            l = line.strip()
            l = re.sub(r'\s+', ' ', l)

            if '}' in l:
                depth -= 1

            text_out.append(f"{"\t" * depth}{l}\n")

            if '{' in l:
                depth += 1

    return "".join(text_out)
