## Check if a 3dsx has a RomFS
## This is true when the extHeader is available and romfsOffset is not zero

import nimtenbrew/ctr/binary, streams

let stream = newFileStream("./tests/data/ctr/icon_romfs.3dsx", fmRead)

assert(not stream.isNil)
let header = toCtrHeader(stream.readStr(BINARY_HEADER_SIZE.int))
assert(header.headerSize > BINARY_HEADER_SIZE)
let extHeader = toCtrExtendedHeader(stream.readStr(EXTENDED_HEADER_SIZE.int))
assert(extHeader.romfsOffset > 0)

stream.close()
