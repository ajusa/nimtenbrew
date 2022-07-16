import binarylang


## tex3ds subtexture
## https://github.com/devkitPro/citro3d/blob/master/include/tex3ds.h#L43-L51
struct(*tex3dsSubtexture, endian = l):
    u16: *width
    u16: *height

    u16: *left
    u16: *top
    u16: *right
    u16: *bottom

## tex3ds header
## https://github.com/devkitPro/citro3d/blob/master/source/tex3ds.c#L34-L42
struct(*tex3dsHeader, endian = l):
    u16: *subTextureCount

    ru3: *widthLogTwo
    ru3: *heightLogTwo

    ru1: *gpuTextureType
    ru1: _
    u8: *gpuTextureFormat
    u8: *mipmapLevels

    *tex3dsSubtexture: *subTextures[subTextureCount]

proc getPowerTwoDimensions*(header: Tex3dsHeader): (int, int) =
    return (cast[int](1 shl (header.widthLogTwo + 3)), cast[int](1 shl (header.heightLogTwo + 3)))

proc isCubeMapSkybox*(header: Tex3dsHeader): bool =
    return cast[bool]((header.gpuTextureType and (1 shl 6)))

proc getDimensions*(subTexture: Tex3dsSubtexture): (int, int) =
    return (cast[int](subTexture.width), cast[int](subTexture.height))

proc getCorners*(subTexture: Tex3dsSubtexture): auto =
    return ((subTexture.left, subTexture.left.float / 1024.0),
             (subTexture.top, subTexture.top.float / 1024.0),
             (subTexture.right, subTexture.right.float / 1024.0),
             (subTexture.bottom, subTexture.bottom.float / 1024.0))

export toTex3dsHeader
