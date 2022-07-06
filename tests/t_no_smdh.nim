## Check if a 3dsx has no embedded smdh
## This is true if the headerSize field equals 32

import nimtenbrew/ctr/binary, streams

let stream = newFileStream("./tests/data/ctr/no_smdh.3dsx", fmRead)

assert(not stream.isNil)
let header = toCtrHeader(stream.readAll())
assert(header.headerSize == BINARY_HEADER_SIZE)

stream.close()
