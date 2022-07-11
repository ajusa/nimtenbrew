import flatty/encode

import strutils

proc toUtf16*(str: string, align: int): seq[uint16] =
    ## Converts to UTF-16LE

    let converted = encode.toUtf16LE(str)
        .alignLeft(align, '\0')

    for index in 0 ..< len(converted):
        result.add(converted[index].uint16)

    return result

proc toUtf8*(str: seq[uint16]): string =
    ## Converts to UTF-8 from UTF16

    let utf16String = cast[string](str)
    return encode.fromUTF16LE(utf16String).replace("\0", "")

proc toUtf8*(str: seq[uint8]): string =
    ## Converts to UTF-8

    return cast[string](str).replace("\0", "")
