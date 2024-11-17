// Browser inter-operation bindings

// Types

type window
@val external window: window = "window"

type document
@val external doc: document = "document"

type sessionStorage
@val external sessionStorage: sessionStorage = "sessionStorage"

type rec element = {
  mutable innerText?: string,
  mutable href?: string,
  mutable id?: string,
  lastElementChild?: element,
}

module Response = {
  type t<'data>
  @send external json: t<'data> => promise<'data> = "json"
}


// Browser functions

@send external createElement: (document, string) => element = "createElement"
@send external appendChild: (element, element) => () = "appendChild"
@send external removeChild: (element, element) => unit = "removeChild"
@send external prepend: (element, element) => () = "prepend"
@send external before: (element, element) => () = "before"
@send external getItem: (sessionStorage, string) => string = "getItem"

@send external getElementById: (document, string) =>
  option<element> = "getElementById"

@send external getElementsByTagName: (document, string) =>
  array<element> = "getElementsByTagName"

@send external addEventListener: (window, string, 'a => promise<unit>) =>
  unit = "addEventListener"

// Helper functions

let getBody = () => Option.getExn(getElementsByTagName(doc, "body")[0], ~message="body not found")

// Exceptions

exception ElementNotFound(string)
