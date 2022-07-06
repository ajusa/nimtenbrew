import strutils
import strformat

const NimblePkgVersion* {.strdefine.} = ""

type
    Error* = enum
        FailedToOpen = "Failed to open `$1`"
        InvalidCtrIconSize = "Invalid icon size: $1x$2, expected $3x$3"
        InvalidIconData = "Invalid icon data!"

proc error*(error: Error, args: varargs[string, `$`]) =
    raise newException(Exception, fmt("Error: {($error).format(args)} Aborting."))
