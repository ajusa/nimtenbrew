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
