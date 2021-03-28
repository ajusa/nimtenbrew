# nimtenbrew
Useful parsing stuff for nintendo homebrew

# API: nimtenbrew

```nim
import nimtenbrew
```

## **type** Ctrtitle


```nim
Ctrtitle = ref object
 shortDescriptionImpl*: seq[int8]
 longDescriptionImpl*: seq[int8]
 publisherImpl*: seq[int8]
```

## **proc** shortDescription


```nim
proc shortDescription(:tmp_16960951: Ctrtitle): auto
```

## **proc** shortDescription=


```nim
proc shortDescription=(:tmp_16960958: var Ctrtitle; x: any)
```

## **proc** longDescription


```nim
proc longDescription(:tmp_16960959: Ctrtitle): auto
```

## **proc** longDescription=


```nim
proc longDescription=(:tmp_16960960: var Ctrtitle; x: any)
```

## **proc** publisher


```nim
proc publisher(:tmp_16960961: Ctrtitle): auto
```

## **proc** publisher=


```nim
proc publisher=(:tmp_16960962: var Ctrtitle; x: any)
```

## **let** ctrtitle


```nim
ctrtitle = (get: :tmp_16960963, put: :tmp_16960964)
```

## **type** Ctrbin


```nim
Ctrbin = ref object
 file*: seq[int8]
 version*: int16
 reserved1*: int16
 titles*: seq[Ctrtitle]
 settings*: seq[int8]
 reserved2*: seq[int8]
 smallIcon*: seq[int8]
 largeIcon*: seq[int8]
 romfs*: seq[int8]
```

## **let** ctrbin


```nim
ctrbin = (get: :tmp_17020082, put: :tmp_17020083)
```

## **proc** setTitles


```nim
proc setTitles(bin: var Ctrbin;
 shortDescription, longDescription, publisher: string) {.raises: [EncodingError, OSError].}
```

## **type** Hactitle


```nim
Hactitle = ref object
 nameImpl*: seq[int8]
 publisherImpl*: seq[int8]
```

## **proc** name


```nim
proc name(:tmp_17135349: Hactitle): auto
```

## **proc** name=


```nim
proc name=(:tmp_17135350: var Hactitle; x: any)
```

## **proc** publisher


```nim
proc publisher(:tmp_17135351: Hactitle): auto
```

## **proc** publisher=


```nim
proc publisher=(:tmp_17135352: var Hactitle; x: any)
```

## **let** hactitle


```nim
hactitle = (get: :tmp_17135353, put: :tmp_17135354)
```

## **type** Nacpsection


```nim
Nacpsection = ref object
 titles*: seq[Hactitle]
 settings*: seq[int8]
```

## **let** nacpsection


```nim
nacpsection = (get: :tmp_17145028, put: :tmp_17145029)
```

## **proc** setTitles


```nim
proc setTitles(nacp: var Nacpsection; name, publisher: string)
```

## **type** Hacbin


```nim
Hacbin = ref object
 headers*: seq[int8]
 assets*: Assetheader
 imageImpl*: seq[int8]
 nacp*: Nacpsection
 romfs*: seq[int8]
```

## **proc** image


```nim
proc image(:tmp_17265052: Hacbin): auto
```

## **proc** image=


```nim
proc image=(:tmp_17265053: var Hacbin; x: any)
```

## **let** hacbin


```nim
hacbin = (get: :tmp_17265054, put: :tmp_17265055)
```
