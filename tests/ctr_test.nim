import nimtenbrew, print, bitstreams
var file = readFile("test.3dsx")
var obj = file.toCTRBin()
assert(obj.fromCTRBin == file)
for title in obj.titles.mitems:
    echo title.shortDescription
    echo title.longDescription
    echo title.publisher
    title.publisher = "ajusa"
