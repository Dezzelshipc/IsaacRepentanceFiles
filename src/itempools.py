import itertools
from pathlib import Path

from slpp import slpp as lua
from utility import url_dict, fix_lua_indent, recursive_dict, get_single_root

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
        ItemPools = get_single_root(url, "/itempools.xml")

        for Pool in ItemPools:
            pool = Pool.attrib["Name"]

            result[pool][dlc] = list(sorted(get_item_weight(Item.attrib, is_dict) for Item in Pool))
            weights = weights.union(map(lambda x: len(x) > 1 and x[1] or 1.0, result[pool][dlc]))

            if is_dict:
                result[pool][dlc] = dict(result[pool][dlc])

    print(list(sorted(weights)))

    return result


def get_listed_pools(itempools):

    result_pool_id = recursive_dict()
    result_id_pool = recursive_dict()

    for itempool, dlc_pools in itempools.items():
        items_set = list(sorted({_id for items in dlc_pools.values() for _id in items.keys()}))

        for _id in items_set:
            weights = [dlc_pools.get(dlc, {}).get(_id, 0) for dlc in dlc_order.keys()]
            result_pool_id[itempool][_id] = weights
            result_id_pool[_id][itempool] = weights

    result_id_pool = dict(sorted(result_id_pool.items()))

    print(",".join(itempools.keys()))

    print(dict(zip(itempools.keys(), itertools.cycle(("",)))))

    return result_id_pool, result_pool_id


def main():
    _itempools = get_itempools(True)

    _id_pool, _pool_id = get_listed_pools(_itempools)

    return (
        fix_lua_indent(lua.encode(_itempools)),
        fix_lua_indent(lua.encode(_id_pool)),
        fix_lua_indent(lua.encode(_pool_id))
    )

if __name__ == "__main__":
    itempools, id_pool, pool_id = main()

    save_path = Path(__file__).parent / "itempools_out"
    save_path.mkdir(parents=True, exist_ok=True)

    with open(save_path / "itempools_out.lua", "w") as f:
        f.write(itempools)

    with open(save_path / "itempools_pool_id_out.lua", "w") as f:
        f.write(pool_id)

    with open(save_path / "itempools_id_pool_out.lua", "w") as f:
        f.write(id_pool)
