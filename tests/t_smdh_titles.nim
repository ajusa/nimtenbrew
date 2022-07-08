## Output the smdh titles
## This is possible when the extHeader is available

import nimtenbrew/ctr/binary
import nimtenbrew/ctr/smdh

import streams

let stream = newFileStream("./tests/data/ctr/icon_romfs.3dsx", fmRead)

assert(not stream.isNil)
let header = toCtrHeader(stream.readStr(BINARY_HEADER_SIZE.int))
assert(header.headerSize > BINARY_HEADER_SIZE)
let extHeader = toCtrExtendedHeader(stream.readStr(EXTENDED_HEADER_SIZE.int))
assert(extHeader.smdhOffset > 0)
stream.setPosition(extHeader.smdhOffset.int)
let smdhData = toSmdh(stream.readStr(extHeader.smdhSize.int))

let titles = smdhData.getTitles()

for title in titles:
    assert(title[0] == "romfs")
    assert(title[1] == "Built with devkitARM & libctru")
    assert(title[2] == "Unspecified Author")

stream.close()
