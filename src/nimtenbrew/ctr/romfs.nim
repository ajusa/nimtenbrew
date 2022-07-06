import binarylang

## RomFS Header
## https://www.3dbrew.org/wiki/RomFS#Format
struct(*romfs, endian = l):
    s: *magic = "IVFC"
    u32: *magicNumber = 0x10000
    u32: masterHashSize

    u64: levelOneLogicOffset
    u64: levelOneHashSize
    u32: levelOneLog2BlockSize

    u32: reserved

    u64: levelTwoLogicOffset
    u64: levelTwoHashSize
    u32: levelTwoLog2BlockSize

    u32: reservedTwo

    u64: levelThreeLogicOffset
    u64: levelThreeHashSize
    u32: levelThreeLog2BlockSize

    u32: reservedThree
    u32: reservedFour

    u32: size

const ROMFS_STRUCT_SIZE*: uint = 0x60

export toRomfs
