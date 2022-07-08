import nimtenbrew/hac/binary
import nimtenbrew/hac/assets
import nimtenbrew/hac/nacp

import std/unittest

import streams
import strformat
import strutils

const FILEPATH = "./tests/data/hac"

suite "Hac Testing":

    let ICON_ROMFS = newFileStream(&"{FILEPATH}/icon_romfs.nro", fmRead)
    assert(not ICON_ROMFS.isNil, "icon_romfs FileStream is nil")

    let ICON_NO_ROMFS = newFileStream(&"{FILEPATH}/icon_no_romfs.nro", fmRead)
    assert(not ICON_NO_ROMFS.isNil, "icon_no_romfs FileStream is nil")

    let NO_NACP = newFileStream(&"{FILEPATH}/no_nacp.nro", fmRead)
    assert(not NO_NACP.isNil, "no_nacp FileStream is nil")

    const ROMFS_ERROR = "assetHeader romfs: expected size $1, got $2"
    const NACP_ERROR = "assetHeader nacp: expected size $1, got $2"
    const ICON_ERROR = "assetHeader icon: expected size $1, got $2"

    const EXPECTED_TITLE = "romfs"
    const EXPECTED_AUTHOR = "Unspecified Author"

    const INVALID_TITLE = &"title: expected {EXPECTED_TITLE}, got $1"
    const INVALID_AUTHOR = &"author: expected {EXPECTED_AUTHOR}, got $1"

    setup:
        ## Reset FileStreams before running tests, if applicable

        if ICON_ROMFS.getPosition() != 0:
            ICON_ROMFS.setPosition(0)

        if ICON_NO_ROMFS.getPosition() != 0:
            ICON_ROMFS.setPosition(0)

        if NO_NACP.getPosition() != 0:
            NO_NACP.setPosition(0)

    test "nro with Assets":
        discard toHacStart(ICON_ROMFS.readStr(START_SIZE.int))
        let header = toHacHeader(ICON_ROMFS.readStr(NRO_HEADER_SIZE.int))

        ICON_ROMFS.setPosition(0)
        discard ICON_ROMFS.readStr(header.totalSize.int)

        let assetsHeader = toAssetsHeader(ICON_ROMFS.readStr(ASSETS_HEADER_SIZE.int))

        let iconSize = assetsHeader.icon.size
        let nacpSize = assetsHeader.nacp.size
        let romfsSize = assetsHeader.romfs.size

        assert(iconSize > 0, ROMFS_ERROR.format("> 0", iconSize))
        assert(nacpSize > 0, NACP_ERROR.format("> 0", nacpSize))
        assert(romfsSize > 0, ICON_ERROR.format("> 0", romfsSize))

    test "nro with no Assets":
        discard toHacStart(NO_NACP.readStr(START_SIZE.int))
        let header = toHacHeader(NO_NACP.readStr(NRO_HEADER_SIZE.int))

        NO_NACP.setPosition(0)
        discard NO_NACP.readStr(header.totalSize.int)

        let assetsHeader = toAssetsHeader(NO_NACP.readStr(ASSETS_HEADER_SIZE.int))

        let iconSize = assetsHeader.icon.size
        let nacpSize = assetsHeader.nacp.size
        let romfsSize = assetsHeader.romfs.size

        assert(iconSize > 0, ROMFS_ERROR.format("> 0", iconSize))
        assert(nacpSize == 0, NACP_ERROR.format("== 0", nacpSize))
        assert(romfsSize == 0, ICON_ERROR.format("== 0", romfsSize))

    test "nro Title Information":
        discard toHacStart(ICON_ROMFS.readStr(START_SIZE.int))
        let header = toHacHeader(ICON_ROMFS.readStr(NRO_HEADER_SIZE.int))

        ICON_ROMFS.setPosition(0)
        discard ICON_ROMFS.readStr(header.totalSize.int)

        let assetsHeader = toAssetsHeader(ICON_ROMFS.readStr(ASSETS_HEADER_SIZE.int))

        ICON_ROMFS.setPosition((header.totalSize + assetsHeader.nacp.offset).int)
        let nacpData = toNacp(ICON_ROMFS.readStr(assetsHeader.nacp.size.int))

        let titles = nacpData.getTitles()

        for title in titles:
            assert(title[0] == EXPECTED_TITLE, INVALID_TITLE.format(title[0]))
            assert(title[1] == EXPECTED_AUTHOR, INVALID_AUTHOR.format(title[1]))

    ICON_ROMFS.close()
    ICON_NO_ROMFS.close()
    NO_NACP.close()
