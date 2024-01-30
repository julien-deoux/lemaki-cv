type t

let text: string => t
let createElement: string => (array<(string, string)>, array<t>) => t
let inject: (string, t) => unit
let setInnerHTML: (t, string) => unit
let div: (array<(string, string)>, array<t>) => t
let span: (array<(string, string)>, array<t>) => t
let li: (array<(string, string)>, array<t>) => t
let a: (array<(string, string)>, array<t>) => t
let img: (array<(string, string)>, array<t>) => t
