import binarylang, encodings, strutils, sequtils, binarylang/plugins
proc toUTF16(str: string, size: int): seq[int8] =
    result = newSeq[int8](size)
    let utf16 = cast[seq[int8]](str.convert("utf-16", "utf-8"))
    result.insert(utf16[2..^1])
proc `$`(bytes: seq[int8]): string = cast[string](bytes)
proc toUTF8(str: string, size: int): seq[int8] =
    result = newSeq[int8](size)
    result.insert(cast[seq[int8]](str))
createParser(*ctrtitle):
    8 {@get: $_, @set: _.toUTF16(0x80)}: *shortDescription[0x80]
    8 {@get: $_, @set: _.toUTF16(0x100)}: *longDescription[0x100]
    8 {@get: $_, @set: _.toUTF16(0x80)}: *publisher[0x80]

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

proc setTitles*(bin: var CTRBin, shortDescription, longDescription, publisher: string) =
    for title in bin.titles.mitems:
        title.shortDescription = shortDescription
        title.longDescription = longDescription
        title.publisher = publisher

export toCTRBin
export fromCTRBin

createParser(*hactitle):
    8 {@get: $_, @set: _.toUTF8(0x200)}: *name[0x200]
    8 {@get: $_, @set: _.toUTF8(0x100)}: *publisher[0x100]

createParser(*nacpsection):
    *hactitle: *titles[0x10]
    8: *settings[0x1000]

proc setTitles*(nacp: var NACPSection, name, publisher: string) =
    for title in nacp.titles.mitems:
        title.name = name
        title.publisher = publisher
createParser(assetsection):
    l64: *offset
    l64: *size
createParser(assetheader):
    32: *version
    *assetsection: *icon
    *assetsection: *nacp
    *assetsection: *romfs
proc update(assets: var Assetheader) =
    assets.icon.offset = 56 # size of assetheaders
    assets.nacp.offset = assets.icon.offset + assets.icon.size
    assets.romfs.offset = assets.nacp.offset + assets.nacp.size
    if assets.romfs.size == 0: assets.romfs.offset = 0
createParser(*hacbin):
    8: *{headers}
    s: _ = "ASET"
    *assetheader: *assets
    8 {@hook: (assets.icon.size = _.len; assets.update)}: *icon[assets.icon.size]
    *nacpsection: *nacp
    8 {cond: not s.atEnd}: *romfs{s.atEnd}

export toHACBin
export fromHACBin
