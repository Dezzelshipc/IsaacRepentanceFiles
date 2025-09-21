from slpp import slpp as lua

from utility import fix_lua_indent

import re

itempools = {
    'treasure': 'сокровищ_ф',
    'shop': 'магазин_ф',
    'boss': 'босс_ф',
    'devil': 'дьявол_ф',
    'angel': 'ангел_ф',
    'secret': 'секретная_ф',
    'library': 'библиотека_ф',
    'goldenChest': 'Золотой_ф',
    'redChest': 'Красный_ф',
    'beggar': 'Обычный_ф',
    'demonBeggar': 'Злой_ф',
    'curse': 'проклятая_ф',
    'keyMaster': 'Мастер ключей_ф',
    'bossrush': '',
    'dungeon': '',
    'challenge': '',
    'greedTreasure': 'сокр_гф',
    'greedBoss': 'босс_гф',
    'greedShop': 'магазин_гф',
    'greedCurse': 'проклятая_гф',
    'greedDevil': 'дьявол_гф',
    'greedAngel': 'ангел_гф',
    'greedLibrary': 'библиотека_гф',
    'greedSecret': 'секретная_гф',
    'greedGoldenChest': 'Золотой_гф',
    'bombBum': 'Взрывной_ф',
    'shellGame': 'наперст_ф',
    'batteryBum': 'батар_ф',
    'momsChest': 'мсун_ф',
    'craneGame': 'кран_ф',
    'ultraSecret': 'ультра_ф',
    'planetarium': 'план_ф',
    'oldChest': 'ссун_ф',
    'babyShop': 'бшоп_ф',
    'woodenChest': 'дсун_ф',
    'rottenBeggar': 'гнилой_ф'
}


if __name__ == "__main__":
    with open("name_in.lua", "r", encoding="utf-8") as f:
        data = lua.decode(f.read())

    result = {}

    for _id, values in data.items():
        vals = values.replace(", ", ",").split(",")
        for pool_name in itempools.values():
            if pool_name in vals:
                vals.remove(pool_name)

        result[int(_id)] = ", ".join(vals).lower()

    with open("name_out.lua", "w", encoding="utf-8") as f:
        f.write(fix_lua_indent(lua.encode(result)))