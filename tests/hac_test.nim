import nimtenbrew, sugar
# var file = readFile("LOVEPotion.nacp")
# var obj = file.toNACP()
# assert(obj.fromNACP == file)
# for title in obj.titles.mitems:
#     echo title.name
#     echo title.publisher

var file = readFile("test.nro")
var nro = file.toHACBin
assert nro.fromHACBin == file # Symmetric
nro.nacp.setTitles("My Game", "ajusa")
for title in nro.nacp.titles:
    echo title.publisher
    echo title.name
dump nro.assets.icon.offset
dump nro.assets.icon.size
dump nro.assets.nacp.offset
dump nro.assets.romfs.offset
nro.icon = @[1'i8, 2, 3, 4]
echo "updated icon"
dump nro.assets.icon.offset
dump nro.assets.nacp.offset
dump nro.assets.icon.size
dump nro.assets.romfs.offset
dump nro.assets.romfs.size
# echo nro.iconAsset.offset
# echo nro.nacpAsset.offset
# echo nro.romfsAsset.offset
# echo nro.romfsAsset.size
# echo nro.nacp.size
# writeFile("output.jpeg", cast[string](nro.image))
