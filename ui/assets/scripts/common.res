open Js

type document
type rec element = { lastElementChild: Js.null<element> }

@send external getElementById: (document, string) => element = "getElementById"
@send external removeChild: (element, Js.null<element>) => unit = "removeChild"
@val external doc: document = "document"

let clearChildren = (id: string) => {
  let parent = getElementById(doc, id)
  while !testAny(parent.lastElementChild) {
    removeChild(parent, parent.lastElementChild)
  }
}
