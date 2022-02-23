import flatty, flatty/hexprint, encode, print, strutils
type 
  MagicFill[N : static[string], T] = object
    filled: T
  List[T] = seq[T]
  UTF16[N: static[int]] = object
    value: string
  UTF8[N: static[int]] = object
    value: string
  Rest = string
type
  AppTitle = object
    short: UTF16[0x80]
    long: UTF16[0x100]
    publisher: UTF16[0x80]
  CtrBin = object
    file: MagicFill["SMDH", List[byte]]
    version: uint16
    reserved1: uint16
    titles: array[16, AppTitle]
    settings: array[0x30, byte]
    reserved2: array[0x8, byte]
    smallIcon: array[0x480, byte]
    largeIcon: array[0x1200, byte]
    rest: List[byte]

proc fromFlatty*[T](s: string, i: var int, x: var UTF16[T]) =
  x.value = s[i..<(i+T)].fromUTF16()
  i += T

proc toFlatty*[T](s: var string, x: UTF16[T]) =
  s.add(x.value.toUTF16LE().alignLeft(T, '\0'))

proc fromFlatty*[T](s: string, i: var int, x: var UTF8[T]) =
  x.value = s[i..<(i+T)]
  i += T

proc toFlatty*[T](s: var string, x: UTF8[T]) =
  s.add(x.value.alignLeft(T, '\0'))

proc fromFlatty*(s: string, i: var int, x: void) = discard
proc fromFlatty*[T](s: string, i: var int, x: var List[T]) =
  while i < s.len:
    var j: T
    s.fromFlatty(i, j)
    x.add(j)

proc toFlatty*[T](s: var string, x: List[T]) =
  for i in x:
    s.toFlatty(i)

proc fromFlatty*[N, T](s: string, i: var int, x: var MagicFill[N, T]) =
  var loc = s.find(N, i, last = len(s))
  assert loc != -1
  var tmp: T
  var trunc = s[i..<loc]
  trunc.fromFlatty(i, tmp)
  i = loc + len(N)
  x.filled = tmp

proc toFlatty*[N, T](s: var string, x: MagicFill[N, T]) =
  s.toFlatty(x.filled)
  s.add(N)

var str = readFile("test.3dsx")
echo str.len

var a = str.fromFlatty(CtrBin)
# echo a.titles[0].short
echo a.rest.len
a.titles[0].short.value = "3DSHelloWorld"
assert a.toFlatty() == str
# echo a.titles[0].short.toFlatty().len
# echo a.toFlatty.len
