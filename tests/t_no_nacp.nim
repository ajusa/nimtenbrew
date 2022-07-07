## Check if a nro has no embedded smdh
## This is true if the AssetSection NACP size is zero

import nimtenbrew/hac/binary
import nimtenbrew/hac/assets

import streams

let stream = newFileStream("./tests/data/hac/no_nacp.nro", fmRead)

assert(not stream.isNil)
discard toHacStart(stream.readStr(START_SIZE.int))
let header = toHacHeader(stream.readStr(NRO_HEADER_SIZE.int))

# reset to zero
stream.setPosition(0)
discard stream.readStr(header.totalSize.int)

let assetHeader = toAssetsHeader(stream.readStr(ASSETS_HEADER_SIZE.int))
assert(assetHeader.nacp.size == 0)

stream.close()
