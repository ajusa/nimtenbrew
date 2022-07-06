import ../strings

import strutils
import strformat

import nimPNG
import stew/endians2

proc load*(png_path: string, size: int): string =
    ## Loads a PNG icon at `png_path` with expected size `size`
    ## Returns the data buffer loaded by nimPNG

    try:
        let png = nimPNG.loadPNG32(png_path)

        if png.width != size and png.height != size:
            strings.error(Error.InvalidCtrIconSize)

        return png.data
    except Exception:
        return ""

## https://github.com/devkitPro/3dstools/blob/master/src/smdhtool.cpp#L120-L126
const TILE_ORDER: seq[int] = @[0, 1, 8, 9, 2, 3, 10, 11, 16, 17, 24, 25, 18, 19,
        26, 27, 4, 5, 12, 13, 6, 7, 14, 15, 20, 21, 28, 29, 22, 23, 30, 31, 32,
        33, 40, 41, 34, 35, 42, 43, 48, 49, 56, 57, 50, 51, 58, 59, 36, 37, 44,
        45, 38, 39, 46, 47, 52, 53, 60, 61, 54, 55, 62, 63]

proc convertToRGB565(a, r, g, b: uint8): uint16 =
    ## Converts ARGB colors to RGB565
    ## https://github.com/devkitPro/3dstools/blob/master/src/smdhtool.cpp#L274-L285

    var newRed = ((1.float * r.float * a.float) / 255.float).uint16
    var newGreen = ((1.float * g.float * a.float) / 255.float).uint16
    var newBlue = ((1.float * b.float * a.float) / 255.float).uint16

    newRed = (newRed shr 3)
    newGreen = (newGreen shr 2)
    newBlue = (newBlue shr 3)

    return toLE((newRed shl 11) or (newGreen shl 5) or newBlue)

proc blendColor(a, b, c, d: uint8): uint8 =
    ## Blends colors for ctr::smdh::smallIcon
    ## https://github.com/devkitPro/3dstools/blob/master/src/smdhtool.cpp#L287-L295

    result = 0

    result += a
    result += b
    result += c
    result += d

    return (result + 2) div 4

proc convertPNGToIcon*(png_data: string): seq[uint16] =
    ## Converts the `png_data` from `icon::load` to an `smdh::largeIcon`
    ## https://github.com/devkitPro/3dstools/blob/master/src/smdhtool.cpp#L341-417

    if png_data.isEmptyOrWhitespace():
        strings.error(Error.InvalidIconData)

    var largeIcon = newSeq[uint16](0x900)
    var index: int = 0

    for y in countup(0, 48 - 1, 8):
        for x in countup(0, 48 - 1, 8):
            for k in 0 ..< 8 * 8:
                let xx = (TILE_ORDER[k] and 0x07)
                let yy = (TILE_ORDER[k] shr 0x03)

                let arrayIndex = 4 * (48 * (y + yy) + (x + xx))
                var rgba = cast[ptr UncheckedArray[uint8]](unsafeAddr(png_data[arrayIndex]))

                let r = rgba[0].uint8
                let g = rgba[1].uint8
                let b = rgba[2].uint8
                let a = rgba[3].uint8

                largeIcon[index] = convertToRGB565(a, r, g, b)
                index += 1

    return largeIcon
