import binarylang

import strutils

import ../utf

import icon

## SMDH Title Info
## https://www.3dbrew.org/wiki/SMDH#Application_Titles
struct(*smdhTitle, endian = l):
    u16: *shortDescription[0x40]
    u16: *longDescription[0x80]
    u16: *publisher[0x40]

const TITLE_SIZE*: uint = 0x200

## SMDH Application Settings
## https://www.3dbrew.org/wiki/SMDH#Application_Settings
struct(*smdhSettings, endian = l):
    u8: *ratings[0x10]
    u32: *regionLockout
    u8: *matchMakerId[0xC]
    u32: *flags
    u16: *eulaVersion
    u16: zero
    u32: *optimalBannerFrame
    u32: *streetpassId

const SETTINGS_SIZE*: uint = 0x30

## SMDH Header
## https://www.3dbrew.org/wiki/SMDH#Format
struct(*smdh, endian = l):
    s: *magic = "SMDH"
    u16: *version
    u16: zero
    *smdhTitle: *titles[0x10]
    *smdhSettings: *settings
    u8: zeroTwo[0x08]
    u16: *smallIcon[0x240]
    u16: *largeIcon[0x900]

const SMDH_STRUCT_SIZE*: uint = 0x36C0

proc setIcon*(smdh: var Smdh, pngPath: string) =
    ## Sets the icon for the `smdh` from a PNG at `pngPath`

    let pngData = icon.load(pngPath, 48)
    smdh.largeIcon = icon.convertPNGToIcon(pngData)

proc setTitles*(smdh: var Smdh, shortDescription, longDescription,
        publisher: string = "") =
    ## Sets the Title information for the `smdh`

    for title in smdh.titles.mitems:
        if not shortDescription.isEmptyOrWhitespace():
            title.shortDescription = toUtf16(shortDescription, 0x40)

        if not longDescription.isEmptyOrWhitespace():
            title.longDescription = toUtf16(longDescription, 0x80)

        if not publisher.isEmptyOrWhitespace():
            title.publisher = toUtf16(publisher, 0x40)


proc getTitles*(smdh: Smdh): seq[seq[string]] =
    result = newSeq[newSeq[string]()]()

    for title in smdh.titles:
        let value = @[toUtf8(title.shortDescription), toUtf8(
                title.longDescription), toUtf8(title.publisher)]
        result.add(value)

    return result

export toSmdh
