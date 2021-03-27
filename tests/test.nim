import nimtenbrew, print, bitstreams

var fbs = newFileBitStream("LOVEPotion.3dsx")
var obj = smdh.get(fbs)
fbs.close()
for title in obj.titles.mitems:
    echo title.publisher
    # title.publisher = "ajusa"
# print readFile("LOVEPotion.3dsx").toSMDH()
