import nimtenbrew, print, bitstreams
var file = readFile("./test.3dsx")
var obj = file.toCTRBin()
assert(obj.fromCTRBin == file)
for title in obj.titles.mitems:
    title.publisher = "learning to hate stuff"
    title.shortDescription = "man this world is just awful"
    title.longDescription = "man this world is just awful, long"
    echo title.shortDescription
    echo title.longDescription
    echo title.publisher
writeFile("output.3dsx", obj.fromCTRBin)
