## Set a new RomFS

import nimtenbrew/hac/binary
import nimtenbrew/hac/assets

import streams

let stream = newFileStream("./tests/data/hac/icon_romfs.nro", fmRead)

assert(not stream.isNil)
discard toHacStart(stream.readStr(START_SIZE.int))
let header = toHacHeader(stream.readStr(NRO_HEADER_SIZE.int))

# reset to zero
stream.setPosition(0)
discard stream.readStr(header.totalSize.int)

var assetHeader = toAssetsHeader(stream.readStr(ASSETS_HEADER_SIZE.int))

let romfsBuffer = readFile("./tests/data/hac/romfs.bin")
var offset = assetHeader.romfs.offset.int

let originalSize = assetHeader.romfs.size
setRomfs(assetHeader, header.totalSize, len(romfsBuffer).uint, offset)
assert(assetHeader.romfs.size != originalSize and assetHeader.romfs.size.int ==
        len(romfsBuffer))
