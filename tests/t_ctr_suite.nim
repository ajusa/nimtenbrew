## Nintendo 3DS Homebrew Test Suite

import nimtenbrew/ctr/binary
import nimtenbrew/ctr/smdh

import std/unittest

import streams
import strformat
import strutils

const FILEPATH = "./tests/data/ctr"

suite "Ctr Testing":

    let ICON_ROMFS = newFileStream(&"{FILEPATH}/icon_romfs.3dsx", fmRead)
    assert(not ICON_ROMFS.isNil, "icon_romfs FileStream is nil")

    let ICON_NO_ROMFS = newFileStream(&"{FILEPATH}/icon_no_romfs.3dsx", fmRead)
    assert(not ICON_NO_ROMFS.isNil, "icon_no_romfs FileStream is nil")

    let NO_SMDH = newFileStream(&"{FILEPATH}/no_smdh.3dsx", fmRead)
    assert(not NO_SMDH.isNil, "no_smdh FileStream is nil")

    const HEADER_SIZE_TOO_SMALL = &"header size: expected > {BINARY_HEADER_SIZE}, got $1"
    const HEADER_SIZE_INVALID = &"header size: expected == {BINARY_HEADER_SIZE}, got $1"
    const EXTHEADER_OFFSET_ZERO = &"smdhOffset: expected > 0, got $1"

    const EXPECTED_TITLE = "romfs"
    const EXPECTED_DESCRIPTION = "Built with devkitARM & libctru"
    const EXPECTED_AUTHOR = "Unspecified Author"

    const INVALID_TITLE = &"title: expected {EXPECTED_TITLE}, got `$1`"
    const INVALID_DESCRIPTION = &"description: expected {EXPECTED_DESCRIPTION}, got `$1`"
    const INVALID_AUTHOR = &"author: expected {EXPECTED_AUTHOR}, got `$1`"

    setup:
        ## Reset FileStreams before running tests, if applicable

        if ICON_ROMFS.getPosition() != 0:
            ICON_ROMFS.setPosition(0)

        if ICON_NO_ROMFS.getPosition() != 0:
            ICON_ROMFS.setPosition(0)

        if NO_SMDH.getPosition() != 0:
            NO_SMDH.setPosition(0)

    test "3dsx with Extended Header":
        let header = toCtrHeader(ICON_ROMFS.readStr(BINARY_HEADER_SIZE.int))
        let size = header.headerSize

        assert(size > BINARY_HEADER_SIZE, HEADER_SIZE_TOO_SMALL.format(size))

    test "3dsx with no Extended Header":
        let header = toCtrHeader(NO_SMDH.readStr(BINARY_HEADER_SIZE.int))
        let size = header.headerSize

        assert(size == BINARY_HEADER_SIZE, HEADER_SIZE_INVALID.format(size))

    test "3dsx Title information":
        let header = toCtrHeader(ICON_ROMFS.readStr(BINARY_HEADER_SIZE.int))
        let size = header.headerSize

        assert(size > BINARY_HEADER_SIZE, HEADER_SIZE_TOO_SMALL.format(size))

        let extHeaderBuffer = ICON_ROMFS.readStr(EXTENDED_HEADER_SIZE.int)
        let extHeader = toCtrExtendedHeader(extHeaderBuffer)
        let offset = extHeader.smdhOffset

        assert(offset > 0, EXTHEADER_OFFSET_ZERO.format(offset))

        ICON_ROMFS.setPosition(offset.int)
        let smdhData = toSmdh(ICON_ROMFS.readStr(extHeader.smdhSize.int))

        let titles = smdhData.getTitles()

        for title in titles:
            assert(title[0] == EXPECTED_TITLE, INVALID_TITLE.format(title[0]))
            assert(title[1] == EXPECTED_DESCRIPTION, INVALID_DESCRIPTION.format(title[1]))
            assert(title[2] == EXPECTED_AUTHOR, INVALID_AUTHOR.format(title[2]))


    ICON_ROMFS.close()
    ICON_NO_ROMFS.close()
    NO_SMDH.close()
