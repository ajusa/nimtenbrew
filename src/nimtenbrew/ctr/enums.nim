type
    GPU_TEXCOLOR* = enum
        GPU_RGBA8 = 0x0
        GPU_RGB8 = 0x1
        GPU_RGBA5551 = 0x2
        GPU_RGB565 = 0x3
        GPU_RGBA4 = 0x4
        GPU_LA8 = 0x5
        GPU_HILO8 = 0x6
        GPU_L8 = 0x7
        GPU_A8 = 0x8
        GPU_LA4 = 0x9
        GPU_L4 = 0xA
        GPU_A4 = 0xB
        GPU_ETC1 = 0xC
        GPU_ETC1A4 = 0xD

type
    GPU_TEXTURE_MODE_PARAM* = enum
        GPU_TEX_2D = 0x0
        GPU_TEX_CUBE_MAP = 0x1
        GPU_TEX_SHADOW_2D = 0x2
        GPU_TEX_PROJECTION = 0x3
        GPU_TEX_SHADOW_CUBE = 0x4
        GPU_TEX_DISABLED = 0x5
