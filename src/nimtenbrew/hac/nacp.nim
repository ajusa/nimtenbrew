import binarylang

import ../utf

## ApplicationTitle
## https://switchbrew.org/wiki/NACP#ApplicationTitle
struct(*appTitle, endian = l):
    u8: *name[0x200]
    u8: *author[0x100]

const APP_TITLE_SIZE*: uint = 0x300

## Nacp
## https://github.com/switchbrew/switch-tools/blob/master/src/nacptool.c#L16-L49
struct(*nacp, endian = l):
    *appTitle: *appTitles[0x0C]
    *appTitle: appTitlesUnk[0x04]

    u8: x3000Unk[0x24]
    u32: x3024Unk
    u32: x3028Unk
    u32: x302CUnk
    u32: x3030Unk
    u32: x3034Unk
    u64: titleId0

    u8: x3040Unk[0x20]
    u8: *version[0x10]

    u64: *titleIdDLCBase
    u64: *titleId1

    u32: x3080Unk
    u32: x3084Unk
    u32: x3088Unk
    u8: x308CUnk[0x24]

    u64: *titleId2
    u64: *titleIds[0x07]

    u32: x30F0Unk
    u32: x30F4Unk

    u64: *titleId3

    u8: *bcatPassphrase[0x40]
    u8: x3140Unk[0xEC0]

const NACP_STRUCT_SIZE*: uint = 0x4000

proc getTitles*(nacp: Nacp): seq[seq[string]] =
    let titles = nacp.appTitles

    for title in titles:
        let values = @[toUtf8(title.name), toUtf8(title.author)]
        result.add(values)

    return result

proc setTitles*(nacp: Nacp, name: string = "", author: string = "") =
    var titles = nacp.appTitles

    for title in titles:
        title.name = utf.toUtf8(name, 0x200)
        title.author = utf.toUtf8(author, 0x200)
