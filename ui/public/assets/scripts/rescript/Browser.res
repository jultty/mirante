// Browser interop bindings

// Types

type window
@val external window: window = "window"

type document
@val external doc: document = "document"

type sessionStorage
@val external storage: sessionStorage = "sessionStorage"

type object
@val external object: object = "Object"

type form
type event

type rec element = {
  mutable innerText?: string,
  mutable href?: string,
  mutable id?: string,
  mutable name?: string,
  mutable value?: string,
  lastElementChild?: element,
  mutable onclick?: () => (),
  @as("for") mutable for_?: string,
  @as("type") mutable type_?: string,
  children?: array<element>,
}

module Response = {
  type t<'data, 'request>
  @send external json: t<'data, 'request> => promise<'data> = "json"
  @send external clone: t<'body, 'request> => promise<'root> = "clone"
}

type response = {
  status?: int,
  statusText?: string,
  url?: string,
  redirected?: bool,
  ok?: bool,
  __client_error?: string,
}

type response_body = {
  status?: int,
  email?: string,
  token?: string,
  __client_error?: string,
}

type response_store = {
  mutable response?: response,
  mutable json?: response_body,
}

// Browser functions

%%private(
@send external putInStorage: (sessionStorage, string, string) => () = "setItem"
@send external getFromStorage: (sessionStorage, string) => Nullable.t<string> = "getItem"
@send external createElement: (document, string) => element = "createElement"
)

@send external appendChild: (element, element) => () = "appendChild"
@send external removeChild: (element, element) => unit = "removeChild"
@send external prepend: (element, element) => () = "prepend"
@send external before: (element, element) => () = "before"
@send external preventDefault: (event) => unit = "preventDefault"

@send external getElementById: (document, string) =>
  option<element> = "getElementById"

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
  promise<Response.t<response_body, response>> = "fetch"

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

let submitListen = (element, function: event => promise<'a>) => addEventListener(element, "submit", function)

let listenFromWindow = (window, event, function: event => promise<'a>) =>
  addWindowEventListener(window, event, function)

let retrieve = (key: string): option<string> => {
  Nullable.toOption(getFromStorage(storage, key))
}

let store = (key: string, contents: string): () => putInStorage(storage, key, contents)
let makeElement = (element: string): element => createElement(doc, element)

module FormBuilder = {

  type field = {
    id: string,
    kind: string,
    label: string,
  }

  let make_field = (form, field: field) => {

    let id: string = field.id

    let label = createElement(doc, "label")
    label.for_ = Some(id)
    label.innerText = Some(field.label)
    appendChild(form, label)
    appendChild(form,
      createElement(doc, "br"))

    let input = createElement(doc, "input")
    input.type_ = Some(field.kind)
    input.id = Some(id)
    input.name = Some(id)
    appendChild(form, input)
    appendChild(form,
      createElement(doc, "br"))
  }

  let make_submit_button = (form: element, text: string) => {
    let button = createElement(doc, "input")
    button.type_ = Some("submit")
    button.value = Some(text)
    appendChild(form, button)
  }

  let make_form = (fields: array<field>, id: string): element => {

    let form = createElement(doc, "form")

    Array.forEach(fields, (field) => {
      make_field(form, field)
    })

    make_submit_button(form, "Enviar")

    form.id = Some(id)
    form
  }
}
