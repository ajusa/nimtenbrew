import flatty, flatty/hexprint, encode, print, strutils
type 
  MagicFill[N : static[string], T] = distinct T
  Magic[N : static[string]] = MagicFill[N, void]
  Size[N : static[int], T] = distinct T
  List[T] = seq[T]
  UTF16 = string
type
  AppTitle = object
    short: Size[0x80, UTF16]
    long: Size[0x100, UTF16]
    publisher: Size[0x80, UTF16]
  CtrBin = object
    file: MagicFill["SMDH", List[byte]]
    version: uint16
    reserved: uint16
    titles: array[16, AppTitle]

converter fromSize[N, T](x: Size[N, T]): T = cast[T](x)
converter toSize[N, T](x: T): Size[N, T] = cast[Size[N, T]](x)

converter fromMagicFill[N, T](x: MagicFill[N, T]): T = cast[T](x)
converter toMagicFill[N, T](x: T): MagicFill[N, T] = cast[MagicFill[N, T]](x)

proc fromFlatty*(s: string, i: var int, x: var UTF16) =
  x = s.fromUTF16()
  i += s.len

proc fromFlatty*[N, T](s: string, i: var int, x: var Size[N, T]) =
  var upper = i + N
  var trunc = s[i..<upper]
  var tmp: T
  trunc.fromFlatty(i, tmp)
  x = cast[Size[N, T]](tmp)

proc fromFlatty*(s: string, i: var int, x: void) = discard
proc fromFlatty*[T](s: string, i: var int, x: var List[T]) =
  while i < s.len:
    var j: T
    s.fromFlatty(i, j)
    x.add(j)

proc fromFlatty*[N, T](s: string, i: var int, x: var MagicFill[N, T]) =
  var loc = s.find(N, i, last = len(s))
  assert loc != -1
  var tmp: T
  var trunc = s[i..<loc]
  trunc.fromFlatty(i, tmp)
  i = loc + len(N)
  x = cast[MagicFill[N, T]](tmp)



var str = readFile("test.3dsx")

var a = str.fromFlatty(CtrBin)
# var b = str.fromFlatty(MagicFill["SMDH", List[byte]])
echo a
# echo a.file.len
