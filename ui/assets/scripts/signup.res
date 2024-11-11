// Interop bindings

type document
type form
type event
type object
type sessionStorage
type form_data
type rec element = { mutable innerText: Js.null<string> }

@val external doc: document = "document"
@val external object: object = "Object"

@send external getElementById: (document, string) => element = "getElementById"
@send external addEventListener: (element, string, 'a => promise<unit>) => unit = "addEventListener"
@send external preventDefault: (event) => unit = "preventDefault"

type fields
@new external parseFields: element => object = "FormData"
@send external parseForm: (object, object) => form_data = "fromEntries"

@val external sessionStorage: sessionStorage = "sessionStorage"
@send external getItem: (sessionStorage, string) => string = "getItem"

module Response = {
  type t<'data>
  @send external json: t<'data> => promise<'data> = "json"
}

// Data models

type credentials = { email: string, token: string }
type credentials_store = { mutable email: string, mutable token: string }
type sign_up_data = { email: string, password: string, }

@scope("JSON")
@val external parseCredentials: string => credentials = "parse"

@scope("JSON")
@val external stringifyCredentials: credentials => string = "stringify"


@val @scope("globalThis")
external fetch: (
  string,
  'params,
) => promise<Response.t<{"status": Nullable.t<int>}>> =
  "fetch"

// Status logic

let form: element = getElementById(doc, "account_creation_form")
let dialog: element = getElementById(doc, "user_dialog")

let sign_up_handler = async (event) => {
  preventDefault(event)
  dialog.innerText = Null.make("")

  let form_data = parseForm(object, parseFields(form))

  let post_options = {
    "method": "POST",
    "headers": { "Content-Type": "application/json" },
    "body": JSON.stringifyAny(form_data) }

  let credentials_store : credentials_store = { email: "", token: "" }

  try {
    let response = await fetch("http://localhost:3031/rpc/signup", post_options)
    let response_json = await response->Response.json

    Console.log(response)
    Console.log(response_json)

    // if (response.status == 200 || response.status == 201) {
    //   credentials_store.email = response_json.email
    //   credentials_store.password = response_json.password
    // }


  } catch {
  | _ => {
    Console.log(Error("Erro na requisição"))
    dialog.innerText = Null.make("Erro na requisição")
    () // TODO: should exit the function here, does it?
  }
}
  // let fetch_options = {
  //   "method": "POST",
  //   "headers": { "Content-Type": "application/json" },
  //   "body": stringifyCredentials(form_data),
  // }


}

addEventListener(form, "submit", sign_up_handler)
