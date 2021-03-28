import binarylang, encodings, strutils, sequtils, binarylang/plugins
proc toBytes(str: string, size: int, encoding = "utf-8"): seq[int8] =
    result = newSeq[int8](size)
    let utf16 = cast[seq[int8]](str.convert(encoding, "utf-8"))
    result.insert(utf16[2..^1])
proc `$`(bytes: seq[int8]): string = cast[string](bytes)
proc toUTF8(str: string, size: int): seq[int8] =
    result = newSeq[int8](size)
    let utf8 = cast[seq[int8]](str)
    for i in 0..<utf8.len: result[i] = utf8[i] # skip the byte order mark
createParser(*ctrtitle):
    8 {@get: $_, @set: _.toBytes(0x80, "utf-16")}: *shortDescription[0x80]
    8 {@get: $_, @set: _.toBytes(0x100, "utf-16")}: *longDescription[0x100]
    8 {@get: $_, @set: _.toBytes(0x80, "utf-16")}: *publisher[0x80]

createParser(*ctrbin):
    8: *{file}
    s: _ = "SMDH"
    16: *version
    16: *reserved1 #reserved
    *ctrtitle: *titles[16]
    8: *settings[0x30]
    8: *reserved2[0x8] #reserved
    8: *smallIcon[0x480]
    8: *largeIcon[0x1200]
    8 {cond: not s.atEnd}: *romfs{s.atEnd}

export toCTRBin
export fromCTRBin

createParser(*hactitle):
    8 {@get: $_, @set: _.toBytes(0x200)}: *name[0x200]
    8 {@get: $_, @set: _.toBytes(0x100)}: *publisher[0x100]

createParser(*nacpsection):
    *hactitle: *titles[0x10]
    8: *settings[0x1000]
createParser(assetsection):
    l64: *offset
    l64: *size
createParser(assetheader):
    32: *version
    *assetsection: *icon
    *assetsection: *nacp
    *assetsection: *romfs
createParser(*hacbin):
    8: *{headers}
    s: _ = "ASET"
    *assetheader: *assets
    8: *image[assets.icon.size]
    *nacpsection: *nacp
    8 {cond: not s.atEnd}: *romfs{s.atEnd}


export toHACBin
export fromHACBin
