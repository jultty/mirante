open BrowserTypes

// Browser functions

%%private(
@send external putInStorage: (sessionStorage, string, string) => () = "setItem"
@send external getFromStorage: (sessionStorage, string) => Nullable.t<string> = "getItem"
@send external createElement: (document, string) => element = "createElement"
)

@send external appendChild: (element, element) => () = "appendChild"
@send external removeChild: (element, element) => unit = "removeChild"
@send external replace: (element, element) => () = "replaceWith"
@send external prepend: (element, element) => () = "prepend"
@send external before: (element, element) => () = "before"
@send external preventDefault: (event) => unit = "preventDefault"
@send external parseForm: (object, object) => AuthTypes.credentials = "fromEntries"

@new external parseFields: element => object = "FormData"

%%private(
@send external getElementById: (document, string) =>
  option<element> = "getElementById"
)

@send external getElementsByTagName: (document, string) =>
  array<element> = "getElementsByTagName"

%%private(
@send external addWindowEventListener: (window, string, 'a => promise<unit>) =>
  unit = "addEventListener"
)

%%private(
@send external addEventListener: (element, string, 'a => promise<unit>) =>
  unit = "addEventListener"
)

@val @scope("globalThis")
external fetch: (string, 'params) =>
  promise<Response.t<response_body, response, _>> = "fetch"

// Exceptions

exception ElementNotFound(string)
exception CredentialsNotFound(string)

// Helper functions

  let getBody = () =>
    Option.getExn(getElementsByTagName(doc, "body")[0],
      ~message="body not found"
    )

  let getElement = (element: string, getter: string): element => {
    Option.getExn(getElementById(doc, element),
      ~message=`[${getter}] ${element} not found`)
  }

  let getElementsByTag = (tag: string, getter: string): array<element> => {
    let array = getElementsByTagName(doc, tag)
    switch array[0] {
    | Some(_) => array
    | None => raise(ElementNotFound(`[${getter}] No <${tag}> elements found`))
    }
  }

  // returns the first element found with the given tag
  let getElementByTag = (tag: string, getter: string): element => {
    let array = getElementsByTagName(doc, tag)
    switch array[0] {
    | Some(element) => element
    | None => raise(ElementNotFound(`[${getter}] No <${tag}> element found`))
  }
}

let clearChildren = (parent: element) => {

  let array = Option.getOr(parent.children, [])

  while Array.length(array) > 0 {
    removeChild(
      parent,
      Option.getExn(parent.lastElementChild))
  }
}

let listen = (element, event, function: event => promise<'a>) => addEventListener(element, event, function)

let changeListen = (element, function: event => promise<'a>) => addEventListener(element, "change", function)

let submitListen = (element, function: event => promise<'a>) => addEventListener(element, "submit", function)

let listenFromWindow = (window, event, function: event => promise<'a>) =>
  addWindowEventListener(window, event, function)

let retrieve = (key: string): option<string> => {
  Nullable.toOption(getFromStorage(storage, key))
}

let store = (key: string, contents: string): () => putInStorage(storage, key, contents)
let makeElement = (element: string): element => createElement(doc, element)
