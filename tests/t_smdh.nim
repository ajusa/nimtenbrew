## Check if a 3dsx has an embedded smdh
## This is true if the headerSize field is bigger than 32

import nimtenbrew/ctr/binary, streams

let stream = newFileStream("./tests/data/ctr/icon_no_romfs.3dsx", fmRead)

assert(not stream.isNil)
let header = toCtrHeader(stream.readAll())
assert(header.headerSize > BINARY_HEADER_SIZE)

stream.close()
