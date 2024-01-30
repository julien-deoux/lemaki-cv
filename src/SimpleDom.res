type t
@val @scope("document") external domCreateElement: string => t = "createElement"
@val @scope("document") external getElementById: string => option<t> = "getElementById"
@send external setAttribute: (t, string, string) => unit = "setAttribute"
@send external appendChild: (t, t) => unit = "appendChild"
@set external setInnerHTML: (t, string) => unit = "innerHTML"
@new external text: string => t = "Text"

let applyAttributes = (element, attributes) => {
  Array.forEach(attributes, ((name, value)) => {
    setAttribute(element, name, value)
  })
}

let appendChildren = (element, children) => {
  Array.forEach(children, child => appendChild(element, child))
}

let createElement = tagName => (attributes, children) => {
  let element = domCreateElement(tagName)
  applyAttributes(element, attributes)
  appendChildren(element, children)
  element
}

let inject = (string, element) => {
  Option.forEach(getElementById(string), root => appendChild(root, element))
}

let div = createElement("div")
let span = createElement("span")
let li = createElement("li")
let a = createElement("a")
let img = createElement("img")
