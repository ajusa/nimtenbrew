import binarylang

import assets

import streams
import strutils

## NRO Start
## https://switchbrew.org/wiki/NRO#Start
struct(*nroStart, endian = l):
    u32: *unused
    u32: *modOffset
    u8: *padding[0x08]

const START_SIZE*: uint = 0x10

## NRO Segment Header
## https://switchbrew.org/wiki/NRO#SegmentHeader
struct(*nroSegmentHeader, endian = l):
    u32: *offset
    u32: *size

const SEGMENT_HEADER_SIZE*: uint = 0x08

## NRO Header
## https://switchbrew.org/wiki/NRO#Header
struct(*nroHeader, endian = l):
    s: *magic = "NRO0"
    u32: *version
    u32: *totalSize
    u32: *flags
    *nroSegmentHeader: *segmentHeaders[0x03]
    u32: *bssSize
    u32: *reserved
    u8: moduleId[0x20]
    u32: dsoOffset
    u32: reservedTwo
    *nroSegmentHeader: *segmentHeadersTwo[0x03]

const NRO_HEADER_SIZE*: uint = 0x70

proc setIcon*(assets: AssetsHeader, nroSize: uint, jpg_buffer: string,
        buffer: FileStream) =
    ## Set the icon for the NRO

    if jpg_buffer.isEmptyOrWhitespace():
        return

    buffer.setPosition((nroSize + ASSETS_HEADER_SIZE).int)
    buffer.write(jpg_buffer)

    assets.icon.size = len(jpg_buffer).uint64

proc setNacp*(assets: AssetsHeader, nroSize: uint, nacp_buffer: string,
        buffer: FileStream, offset: var int = -1) =
    ## Set the NACP for the NRO
    ## `offset` should be relative to the assetsHeaderSize + iconSize

    if nacp_buffer.isEmptyOrWhitespace():
        return

    if offset == -1:
        offset = assets.nacp.offset.int

    buffer.setPosition(nroSize.int + offset)
    buffer.write(nacp_buffer)

    assets.nacp.size = len(nacp_buffer).uint64

proc setRomfs*(assets: AssetsHeader, nroSize: uint, romfs_buffer: string,
        buffer: FileStream, offset: var int = -1) =
    ## Set the RomFS for the NRO
    ## `offset` should be relative to the assetsHeaderSize + iconSize + nacpSize

    if romfs_buffer.isEmptyOrWhitespace():
        return

    if offset == -1:
        offset = assets.romfs.offset.int

    buffer.setPosition(nroSize.int + offset)
    buffer.write(romfs_buffer)

    assets.nacp.size = len(romfs_buffer).uint64
