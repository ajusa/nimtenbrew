import ../strings

import strutils

import nimPNG
import stew/endians2

proc load*(png_path: string, size: int): string =
    ## Loads a PNG icon at `png_path` with expected size `size`
    ## Returns the data buffer loaded by nimPNG

    try:
        let png = nimPNG.loadPNG32(png_path)

        if png.isNil():
            strings.error(Error.InvalidPNG, png_path)

        if png.width != size and png.height != size:
            strings.error(Error.InvalidCtrIconSize, png.width, png.height, size)

        return png.data
    except Exception:
        strings.error(Error.InvalidPNG, png_path)

proc convertToRGB565(a, r, g, b: float): uint16 =
    ## Converts ARGB colors to RGB565
    ## https://github.com/devkitPro/3dstools/blob/master/src/smdhtool.cpp#L274-L285

    var newRed = ((1.0 * r * a) / 255.0).uint16
    var newGreen = ((1.0 * g * a) / 255.0).uint16
    var newBlue = ((1.0 * b * a) / 255.0).uint16

    newRed = (newRed shr 3)
    newGreen = (newGreen shr 2)
    newBlue = (newBlue shr 3)

    return toLE((newRed shl 11) or (newGreen shl 5) or newBlue)

proc convertPNGToIcon*(png_data: string): seq[uint16] =
    ## Converts the `png_data` from `icon::load` to an `smdh::largeIcon`
    if png_data.isEmptyOrWhitespace():
        strings.error(Error.InvalidIconData)
    
    const HEIGHT = 48
    var largeIcon = newSeq[uint16](HEIGHT * HEIGHT) # square, so height = width

    var i = 0
    proc tile(x = 0, y = 0, length: int) =
        if length == 1:
            var rgba = cast[ptr UncheckedArray[uint8]](unsafeAddr(png_data[(x + y * HEIGHT) * 4]))
            let r = rgba[0].float
            let g = rgba[1].float
            let b = rgba[2].float
            let a = rgba[3].float

            largeIcon[i] = convertToRGB565(a, r, g, b)
            inc i
            return
        let halfLength = length div 2
        tile(x, y, halfLength)
        tile(x + halfLength, y, halfLength)
        tile(x, y + halfLength, halfLength)
        tile(x + halfLength, y + halfLength, halfLength)

    const NUM_TILES_WIDE = HEIGHT div 8 # tiles are 8x8
    for y in 0..<NUM_TILES_WIDE:
        for x in 0..<NUM_TILES_WIDE:
            tile(x * 8, y * 8, 8)
    return largeIcon
