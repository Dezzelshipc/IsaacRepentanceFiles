from pyscript import document

output_div = document.querySelector("#output")

def items_metadata(_):
    from items_metadata import main
    output_div.innerText = main()

###
def info_display_main(name):
    from info_display import main
    output_div.innerText = main()[name]

def info_display_items(_):
    info_display_main("collectibles")

def info_display_trinkets(_):
    info_display_main("trinkets")

def info_display_cards(_):
    info_display_main("cards")

def info_display_pills(_):
    info_display_main("pills")
###


###
def itempools_main(index):
    from itempools import main
    output_div.innerText = main()[index]

def itempools_pool_dlc_id(_):
    itempools_main(0)

def itempools_pool_id(_):
    itempools_main(2)

def itempools_id_pool(_):
    itempools_main(1)
###

def game_text_main(_):
    from game_text import luatable
    output_div.innerText = luatable()