import binarylang

## NRO Start
## https://switchbrew.org/wiki/NRO#Start
struct(*hacStart, endian = l):
    u32: unused
    u32: *modOffset
    u8: padding[0x08]

const START_SIZE*: uint = 0x10

## NRO Segment Header
## https://switchbrew.org/wiki/NRO#SegmentHeader
struct(*hacSegmentHeader, endian = l):
    u32: *offset
    u32: *size

const SEGMENT_HEADER_SIZE*: uint = 0x08

## NRO Header
## https://switchbrew.org/wiki/NRO#Header
struct(*hacHeader, endian = l):
    s: *magic = "NRO0"
    u32: *version
    u32: *totalSize
    u32: *flags
    *hacSegmentHeader: *segmentHeaders[0x03]
    u32: *bssSize
    u32: reserved
    u8: *moduleId[0x20]
    u32: *dsoOffset
    u32: reservedTwo
    *hacSegmentHeader: *segmentHeadersTwo[0x03]

const NRO_HEADER_SIZE*: uint = 0x70
