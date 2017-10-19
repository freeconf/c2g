module "module"
[ident] "turing-mac"...
{ "{"
namespace "namespace"
[string] "\"http://ex"...
; ";"
prefix "prefix"
[string] "\"tm\""
; ";"
description "descriptio"...
[string] "\"Data mode"...
; ";"
revision "revision"
[revision] "2013-12-27"
{ "{"
description "descriptio"...
[string] "\"Initial r"...
; ";"
} "}"
typedef "typedef"
[ident] "tape-symbo"...
{ "{"
description "descriptio"...
[string] "\"Type of s"...
; ";"
type "type"
[ident] "string"
{ "{"
length "length"
[string] "\"0..1\""
; ";"
} "}"
} "}"
typedef "typedef"
[ident] "cell-index"
{ "{"
description "descriptio"...
[string] "\"Type for "...
; ";"
type "type"
[ident] "int64"
; ";"
} "}"
typedef "typedef"
[ident] "state-inde"...
{ "{"
description "descriptio"...
[string] "\"Type for "...
; ";"
type "type"
[ident] "uint16"
; ";"
} "}"
typedef "typedef"
[ident] "head-dir"
{ "{"
type "type"
[ident] "enumeratio"...
{ "{"
enum "enum"
[ident] "left"
; ";"
enum "enum"
[ident] "right"
; ";"
} "}"
default "default"
[string] "\"right\""
; ";"
description "descriptio"...
[string] "\"Possible "...
; ";"
} "}"
grouping "grouping"
[ident] "tape-cells"
{ "{"
description "descriptio"...
[string] "\"The tape "...
; ";"
list "list"
[ident] "cell"
{ "{"
description "descriptio"...
[string] "\"List of n"...
; ";"
key "key"
[string] "\"coord\""
; ";"
leaf "leaf"
[ident] "coord"
{ "{"
type "type"
[ident] "cell-index"
; ";"
description "descriptio"...
[string] "\"Coordinat"...
; ";"
} "}"
leaf "leaf"
[ident] "symbol"
{ "{"
type "type"
[ident] "tape-symbo"...
{ "{"
length "length"
[string] "\"1\""
; ";"
} "}"
description "descriptio"...
[string] "\"Symbol ap"...
; ";"
} "}"
} "}"
} "}"
container "container"
[ident] "turing-mac"...
{ "{"
description "descriptio"...
[string] "\"State dat"...
; ";"
leaf "leaf"
[ident] "state"
{ "{"
config "config"
false "false"
; ";"
mandatory "mandatory"
[string] "\"true\""
; ";"
type "type"
[ident] "state-inde"...
; ";"
description "descriptio"...
[string] "\"Current s"...
; ";"
} "}"
leaf "leaf"
[ident] "head-posit"...
{ "{"
config "config"
false "false"
; ";"
mandatory "mandatory"
[string] "\"true\""
; ";"
type "type"
[ident] "cell-index"
; ";"
description "descriptio"...
[string] "\"Position "...
; ";"
} "}"
container "container"
[ident] "tape"
{ "{"
description "descriptio"...
[string] "\"The conte"...
; ";"
config "config"
false "false"
; ";"
uses "uses"
[ident] "tape-cells"
; ";"
action "action"
[ident] "rewind"
{ "{"
description "descriptio"...
[string] "\"be kind\""
; ";"
input "input"
{ "{"
leaf "leaf"
[ident] "position"
{ "{"
type "type"
[ident] "int32"
; ";"
} "}"
} "}"
output "output"
{ "{"
leaf "leaf"
[ident] "estimatedT"...
{ "{"
type "type"
[ident] "int32"
; ";"
} "}"
} "}"
} "}"
} "}"
container "container"
[ident] "transition"...
{ "{"
description "descriptio"...
[string] "\"The Turin"...
; ";"
list "list"
[ident] "delta"
{ "{"
description "descriptio"...
[string] "\"The list "...
; ";"
key "key"
[string] "\"label\""
; ";"
unique "unique"
[string] "\"input/sta"...
; ";"
leaf "leaf"
[ident] "label"
{ "{"
type "type"
[ident] "string"
; ";"
description "descriptio"...
[string] "\"An arbitr"...
; ";"
} "}"
container "container"
[ident] "input"
{ "{"
description "descriptio"...
[string] "\"Output va"...
; ";"
leaf "leaf"
[ident] "state"
{ "{"
type "type"
[ident] "state-inde"...
; ";"
description "descriptio"...
[string] "\"New state"...
; ";"
} "}"
leaf "leaf"
[ident] "symbol"
{ "{"
type "type"
[ident] "tape-symbo"...
; ";"
description "descriptio"...
[string] "\"Symbol to"...
; ";"
} "}"
leaf "leaf"
[ident] "head-move"
{ "{"
type "type"
[ident] "head-dir"
; ";"
description "descriptio"...
[string] "\"Move the "...
; ";"
} "}"
} "}"
} "}"
} "}"
} "}"
rpc "rpc"
[ident] "initialize"
{ "{"
description "descriptio"...
[string] "\"Initializ"...
; ";"
input "input"
{ "{"
leaf "leaf"
[ident] "tape-conte"...
{ "{"
type "type"
[ident] "string"
; ";"
default "default"
[string] "\"\""
; ";"
description "descriptio"...
[string] "\"The strin"...
; ";"
} "}"
} "}"
} "}"
rpc "rpc"
[ident] "run"
{ "{"
description "descriptio"...
[string] "\"Start the"...
; ";"
} "}"
notification "notificati"...
[ident] "halted"
{ "{"
description "descriptio"...
[string] "\"The Turin"...
; ";"
leaf "leaf"
[ident] "state"
{ "{"
mandatory "mandatory"
[string] "\"true\""
; ";"
type "type"
[ident] "state-inde"...
; ";"
} "}"
} "}"
} "}"
