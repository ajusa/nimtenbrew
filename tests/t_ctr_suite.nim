## Nintendo 3DS Homebrew Test Suite

import nimtenbrew/ctr/binary
import nimtenbrew/ctr/smdh

import nimtenbrew/ctr/tex3ds
import nimtenbrew/ctr/enums

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

    let ICON_CUSTOM = newFileStream(&"{FILEPATH}/icon_test.3dsx", fmRead)
    assert(not ICON_CUSTOM.isNil, "icon_test FileStream is nil")

    let ICON_PATH = &"{FILEPATH}/test.png"

    let FONT_TEXTURE = newFileStream(&"{FILEPATH}/font.t3x", fmRead)
    assert(not FONT_TEXTURE.isNil, "sprites FileStream is nil")

    const HEADER_SIZE_TOO_SMALL = &"header size: expected > {BINARY_HEADER_SIZE}, got $1"
    const HEADER_SIZE_INVALID = &"header size: expected == {BINARY_HEADER_SIZE}, got $1"
    const EXTHEADER_OFFSET_ZERO = &"smdhOffset: expected > 0, got $1"

    const EXPECTED_TITLE = "romfs"
    const EXPECTED_DESCRIPTION = "Built with devkitARM & libctru"
    const EXPECTED_AUTHOR = "Unspecified Author"

    const INVALID_TITLE = &"title: expected {EXPECTED_TITLE}, got `$1`"
    const INVALID_DESCRIPTION = &"description: expected {EXPECTED_DESCRIPTION}, got `$1`"
    const INVALID_AUTHOR = &"author: expected {EXPECTED_AUTHOR}, got `$1`"

    const INVALID_ICON = "Invalid matching `$1` data at index #$2: expected, $3, got $4"
    const INVALID_ICON_LEN = "Invalid matching `$1` length: expected $2, got $3"

    const EXPECTED_COUNT = 0x01
    const INVALID_COUNT = &"Invalid Subtexture Count: expected {EXPECTED_COUNT}, got $1"

    const EXPECTED_GPU_MODE = ord(GPU_TEX_2D)
    const INVALID_GPU_MODE = &"Invalid GPU_MODE: expected {GPU_TEX_2D}, got $1"

    const EXPECTED_GPU_FORMAT = ord(GPU_RGBA8)
    const INVALID_GPU_FORMAT = &"Invalid GPU_FORMAT: expected {EXPECTED_GPU_FORMAT}, got $1"

    const EXPECTED_CUBE_SKYBOX = false
    const INVALID_CUBEMAP_SKYBOX = &"Invalid value for Cubemap/Skybox: expected `{EXPECTED_CUBE_SKYBOX}`, got `$1`"

    const EXPECTED_MIPMAP_LEVELS = 0x0
    const INVALID_MIPMAP_LEVELS = &"Invalid value for MipMap Levels: expected {EXPECTED_MIPMAP_LEVELS}, got $1"

    const EXPECTED_TEXTURE_WIDTH = 0x400
    const EXPECTED_TEXTURE_HEIGHT = 0x10

    const INVALID_TEXTURE_SIZE = &"Invalid Texture Size: expected {EXPECTED_TEXTURE_WIDTH}x{EXPECTED_TEXTURE_HEIGHT}, got $1x$2"

    const EXPECTED_SUBTEX_WIDTH = 0x200
    const EXPECTED_SUBTEX_HEIGHT = 0x08

    const INVALID_SUBTEXTURE_SIZE = &"Invalid SubTexture Size: expected {EXPECTED_SUBTEX_WIDTH}x{EXPECTED_SUBTEX_HEIGHT}, got $1x$2"

    const EXPECTED_LEFT_CORNER = (1.uint16, 0.0009765625.float)
    const EXPECTED_TOP_CORNER = (960.uint16, 0.9375.float)
    const EXPECTED_RIGHT_CORNER = (513.uint16, 0.5009765625.float)
    const EXPECTED_BOTTOM_CORNER = (448.uint16, 0.4375.float)

    const INVALID_CORNER = &"Invalid `$1` SubTexture Corner: expected $2, got $3"

    setup:
        ## Reset FileStreams before running tests, if applicable

        if ICON_ROMFS.getPosition() != 0:
            ICON_ROMFS.setPosition(0)

        if ICON_NO_ROMFS.getPosition() != 0:
            ICON_ROMFS.setPosition(0)

        if NO_SMDH.getPosition() != 0:
            NO_SMDH.setPosition(0)

        if ICON_CUSTOM.getPosition() != 0:
            ICON_CUSTOM.setPosition(0)

        if FONT_TEXTURE.getPosition() != 0:
            FONT_TEXTURE.setPosition(0)


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

    test "3dsx icon":
        ## Set the Icon for this file

        let header = toCtrHeader(ICON_ROMFS.readStr(BINARY_HEADER_SIZE.int))
        let size = header.headerSize

        assert(size > BINARY_HEADER_SIZE, HEADER_SIZE_TOO_SMALL.format(size))

        let extHeaderBuffer = ICON_ROMFS.readStr(EXTENDED_HEADER_SIZE.int)
        let extHeader = toCtrExtendedHeader(extHeaderBuffer)
        let offset = extHeader.smdhOffset

        assert(offset > 0, EXTHEADER_OFFSET_ZERO.format(offset))

        ICON_ROMFS.setPosition(offset.int)
        var smdhData = toSmdh(ICON_ROMFS.readStr(extHeader.smdhSize.int))

        smdhData.setIcon(ICON_PATH)

        ## Read our Test Example

        let headerTest = toCtrHeader(ICON_CUSTOM.readStr(BINARY_HEADER_SIZE.int))
        let sizeTest = headerTest.headerSize

        assert(sizeTest > BINARY_HEADER_SIZE, HEADER_SIZE_TOO_SMALL.format(sizeTest))

        let extHeaderBufferTest = ICON_CUSTOM.readStr(EXTENDED_HEADER_SIZE.int)
        let extHeaderTest = toCtrExtendedHeader(extHeaderBufferTest)
        let offsetTest = extHeader.smdhOffset

        assert(offsetTest > 0, EXTHEADER_OFFSET_ZERO.format(offsetTest))

        ICON_CUSTOM.setPosition(offsetTest.int)
        var smdhDataTest = toSmdh(ICON_CUSTOM.readStr(extHeaderTest.smdhSize.int))

        let customIconLen = len(smdhData.largeIcon)
        let testIconLen = len(smdhDataTest.largeIcon)

        assert(customIconLen == testIconLen, INVALID_ICON_LEN.format("largeIcon", testIconLen,
                customIconLen))

        for index in 0 ..< customIconLen:
            assert(smdhData.largeIcon[index] == smdhDataTest.largeIcon[index], INVALID_ICON.format(
                    "largeIcon", index, smdhDataTest.largeIcon[index], smdhData.largeIcon[index]))

    test "tex3ds texture":
        let header = toTex3dsHeader(FONT_TEXTURE.readAll())

        let subTextureCount = header.subTextureCount
        assert(subTextureCount == EXPECTED_COUNT, INVALID_COUNT.format(subTextureCount))

        let gpuTextureType = header.gpuTextureType
        assert(gpuTextureType == ord(EXPECTED_GPU_MODE), INVALID_GPU_MODE.format(gpuTextureType))

        let gpuTextureFormat = header.gpuTextureFormat
        assert(gpuTextureFormat == ord(EXPECTED_GPU_FORMAT), INVALID_GPU_FORMAT.format(gpuTextureFormat))

        let cubeMapSkybox = header.isCubeMapSkybox()
        assert(cubeMapSkybox == EXPECTED_CUBE_SKYBOX, INVALID_CUBEMAP_SKYBOX.format(cubeMapSkybox))

        let mipMapLevels = header.mipmapLevels
        assert(mipMapLevels == EXPECTED_MIPMAP_LEVELS, INVALID_MIPMAP_LEVELS.format(mipMapLevels))

        let (powerTwoWidth, powerTwoHeight) = header.getPowerTwoDimensions()
        assert(powerTwoWidth == EXPECTED_TEXTURE_WIDTH and powerTwoHeight ==
                EXPECTED_TEXTURE_HEIGHT, INVALID_TEXTURE_SIZE.format(powerTwoWidth, powerTwoHeight))

        let (subWidth, subHeight) = header.subTextures[0].getDimensions()
        assert(subWidth == EXPECTED_SUBTEX_WIDTH and subHeight == EXPECTED_SUBTEX_HEIGHT,
                INVALID_SUBTEXTURE_SIZE.format(subWidth, subHeight))

        let (leftCorner, topCorner, rightCorner, bottomCorner) = header.subTextures[0].getCorners()

        assert(leftCorner == EXPECTED_LEFT_CORNER, INVALID_CORNER.format("Left",
                EXPECTED_LEFT_CORNER, leftCorner))

        assert(topCorner == EXPECTED_TOP_CORNER, INVALID_CORNER.format("top", EXPECTED_TOP_CORNER, topCorner))

        assert(rightCorner == EXPECTED_RIGHT_CORNER, INVALID_CORNER.format("right",
                EXPECTED_RIGHT_CORNER, rightCorner))

        assert(bottomCorner == EXPECTED_BOTTOM_CORNER, INVALID_CORNER.format("bottom",
                EXPECTED_BOTTOM_CORNER, bottomCorner))


    FONT_TEXTURE.close()
    ICON_ROMFS.close()
    ICON_NO_ROMFS.close()
    NO_SMDH.close()
    ICON_CUSTOM.close()
