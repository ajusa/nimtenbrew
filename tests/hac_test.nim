import nimtenbrew
# var file = readFile("LOVEPotion.nacp")
# var obj = file.toNACP()
# assert(obj.fromNACP == file)
# for title in obj.titles.mitems:
#     echo title.name
#     echo title.publisher

var file = readFile("test.nro")
var nro = file.toHACBin
for title in nro.nacp.titles:
    echo title.publisher
    echo title.name
# echo nro.iconAsset.offset
# echo nro.nacpAsset.offset
# echo nro.romfsAsset.offset
# echo nro.romfsAsset.size
# echo nro.nacp.size
# writeFile("output.jpeg", cast[string](nro.image))
