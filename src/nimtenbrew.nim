import binarylang, encodings, strutils
# var fbs = newFileBitStream("LOVEPotion.3dsx")
# var sbs = newStringBitstream("")
# createParser(test):
#     8: bytes{s.atend}
# var empty = test.get(sbs)
# assert empty.bytes.len == 0
proc toUTF16(str: string, size: int): seq[int8] =
    result = newSeq[int8](size)
    let utf16 = cast[seq[int8]](str.convert("utf-16", "utf-8"))
    for i in 2..<utf16.len: result[i-2] = utf16[i] # skip the byte order mark
proc fromUTF16(bytes: seq[int8]): string = cast[string](bytes)

createParser(apptitle):
    8 {@get: _.fromUTF16, @set: _.toUTF16(0x80)}: shortDescription[0x80]
    8 {@get: _.fromUTF16, @set: _.toUTF16(0x100)}: longDescription[0x100]
    8 {@get: _.fromUTF16, @set: _.toUTF16(0x80)}: *publisher[0x80]

createParser(*smdh):
    8: {file}
    s: _ = "SMDH"
    16: version
    16: reserved1 #reserved
    *apptitle: *titles[16]
    8: settings[0x30]
    8: reserved2[0x8] #reserved
    8: icons[0x1680]

proc toHex(input: seq[int8]): string =
    for i in input: result &= i.toHex
export toSMDH
# var obj = smdh.get(fbs)
# fbs.close()
# for title in obj.titles.mitems:
#     title.publisher = "ajusa"
# var output = newFileBitStream("output.3dsx", fmReadWrite)
# smdh.put(output, obj)
