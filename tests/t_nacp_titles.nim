## Output the title data
## This is true if the AssetSection NACP data is non-zero

import nimtenbrew/hac/binary
import nimtenbrew/hac/assets
import nimtenbrew/hac/nacp

import streams

let stream = newFileStream("./tests/data/hac/icon_no_romfs.nro", fmRead)

assert(not stream.isNil)
discard toHacStart(stream.readStr(START_SIZE.int))
let header = toHacHeader(stream.readStr(NRO_HEADER_SIZE.int))

# reset to zero
stream.setPosition(0)
discard stream.readStr(header.totalSize.int)

let assetHeader = toAssetsHeader(stream.readStr(ASSETS_HEADER_SIZE.int))
assert(assetHeader.nacp.size != 0)

# each asset offset value is based on distance from the header total size
stream.setPosition((header.totalSize + assetHeader.nacp.offset).int)
let nacpData = toNacp(stream.readStr(assetHeader.nacp.size.int))

let titles = nacpData.getTitles()

for title in titles:
    assert(title[0] == "hello-world")
    assert(title[1] == "Unspecified Author")

stream.close()
