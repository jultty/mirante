// Browser interop bindings

open BrowserTypes

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

let submitListen = (element, function: event => promise<'a>) => addEventListener(element, "submit", function)

let listenFromWindow = (window, event, function: event => promise<'a>) =>
  addWindowEventListener(window, event, function)

let retrieve = (key: string): option<string> => {
  Nullable.toOption(getFromStorage(storage, key))
}

let store = (key: string, contents: string): () => putInStorage(storage, key, contents)
let makeElement = (element: string): element => createElement(doc, element)

module FormBuilder = {

  type field = Meta.field

  let make_field = (form, field: field) => {

    let label = makeElement("label")
    label.for_ = Some(field.id)
    label.innerText = field.label

    appendChild(form, label)
    appendChild(form,
      makeElement("br"))

    if field.kind == "select" {

      let select = makeElement("select")
      select.id = Some(field.id)
      select.name = Some(field.id)

      let options = switch field.options {
      | Some(options) => options
      | None => []
      }

      Array.forEach(options, option => {
        let element = makeElement("option")
        element.value = Some(option)
        appendChild(select, element)
      })

      appendChild(form, select)
      appendChild(form,
        makeElement("br"))

    } else {
      let input = makeElement("input")
      input.type_ = Some(field.kind)
      input.id = Some(field.id)
      input.name = Some(field.id)

      appendChild(form, input)
      appendChild(form,
        makeElement("br"))

    }
  }

  let make_submit_button = (form: element, text: string) => {

    let button = makeElement("input")
    button.type_ = Some("submit")
    button.value = Some(text)

    appendChild(form, button)

  }

  let make_form = (fields: array<field>, id: string): element => {

    let form = makeElement("form")

    Array.forEach(fields, (field) => {
      make_field(form, field)
    })

    make_submit_button(form, "Enviar")

    form.id = Some(id)
    form

  }
}
