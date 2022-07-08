import binarylang

struct(*romfsLevel, endian = l):
    u64: *logicOffset
    u64: *hashSize
    u32: *log2BlockSize

## RomFS Header
## https://www.3dbrew.org/wiki/RomFS#Format
struct(*romfs, endian = l):
    s: *magic = "IVFC"
    u32: *magicNumber = 0x10000
    u32: *masterHashSize

    *romfsLevel: *levelOne

    u32: reserved

    *romfsLevel: *levelTwo

    u32: reservedTwo

    *romfsLevel: *levelThree

    u32: reservedThree
    u32: reservedFour

    u32: *size

const ROMFS_STRUCT_SIZE*: uint = 0x60

export toRomfs
