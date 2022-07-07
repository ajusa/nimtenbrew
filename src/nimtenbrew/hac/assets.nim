import binarylang

## Asset Section
## https://switchbrew.org/wiki/NRO#AssetSection
struct(*assetSection, endian = l):
    u64: *offset
    u64: *size

const ASSET_SECTION_SIZE*: uint = 0x10

## Asset Header
## https://switchbrew.org/wiki/NRO#AssetHeader
struct(*assetsHeader, endian = l):
    s: *magic = "ASET"
    u32: *version
    *assetSection: *icon
    *assetSection: *nacp
    *assetSection: *romfs

const ASSETS_HEADER_SIZE*: uint = 0x38

export toAssetsHeader

proc setIcon*(assets: var AssetsHeader, nroSize: uint, size: uint) =
    ## Set the icon AssetSection information for the NRO

    assets.icon.offset = ASSETS_HEADER_SIZE
    assets.icon.size = size.uint64

proc setNacp*(assets: var AssetsHeader, nroSize: uint, size: uint,
        offset: var int = -1) =
    ## Set the NACP AssetSection information for the NRO
    ## `offset` should be relative to the assetsHeaderSize + iconSize

    if offset == -1:
        offset = assets.nacp.offset.int

    assets.nacp.offset = offset.uint64
    assets.nacp.size = size.uint64

proc setRomfs*(assets: var AssetsHeader, nroSize: uint, size: uint,
        offset: var int = -1) =
    ## Set the RomFS AssetSection information for the NRO
    ## `offset` should be relative to the assetsHeaderSize + iconSize + nacpSize

    if offset == -1:
        offset = assets.romfs.offset.int

    assets.romfs.offset = offset.uint64
    assets.romfs.size = size.uint64
