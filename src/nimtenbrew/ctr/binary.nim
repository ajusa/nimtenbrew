import binarylang

const NUMBER_RELOC_TABLES*: uint = 0x03

## 3DSX Header
## https://www.3dbrew.org/wiki/3DSX_Format#Header
struct(*ctrHeader, endian = l):
    s: *magic = "3DSX"
    u16: *headerSize
    u16: *relocationHeaderSize

    u32: *formatVersion
    u32: *flags

    u32: *codeSegmentSize
    u32: *rodataSegmentSize
    u32: *dataSegmentSize
    u32: *bssSize

const BINARY_HEADER_SIZE*: uint = 0x20

## 3DSX Extended Header
## https://www.3dbrew.org/wiki/3DSX_Format#Extended_Header
struct(*ctrExtendedHeader, endian = l):
    u32: *smdhOffset
    u32: *smdhSize
    u32: *romfsOffset

const EXTENDED_HEADER_SIZE*: uint = 0x0C

## 3DSX Relocation Header
## https://www.3dbrew.org/wiki/3DSX_Format#Relocation_Header
struct(*ctrRelocationHeader, endian = l):
    u32: *absolute
    u32: *relative

const RELOCATION_HEADER_SIZE*: uint = 0x08

## 3DSX Relocation
## https://www.3dbrew.org/wiki/3DSX_Format#Relocation
struct(*ctrRelocation, endian = l):
    u16: skip
    u16: patch

const RELOCATION_SIZE*: uint = 0x04

export toCtrHeader
export toCtrExtendedHeader
export toCtrRelocation
export toCtrRelocationHeader
