import binarylang, print, encodings, strutils
var fbs = newFileBitStream("LOVEPotion.nacp")
proc toUTF8(str: string, size: int): seq[int8] =
    result = newSeq[int8](size)
    let utf8 = cast[seq[int8]](str)
    for i in 0..<utf8.len: result[i] = utf8[i] # skip the byte order mark
proc fromUTF8(bytes: seq[int8]): string = cast[string](bytes)

createParser(title):
    8 {@get: _.fromUTF8, @set: _.toUTF8(0x200)}: name[0x200]
    8 {@get: _.fromUTF8, @set: _.toUTF8(0x100)}: publisher[0x100]

createParser(nacp):
    *title: titles[10]

var test = Title()
test.name = "LÖVE Potion"
test.publisher = "TurtleP & NotQuiteApex"
var obj = nacp.get(fbs)
for title in obj.titles:
    echo title[] == test[]
