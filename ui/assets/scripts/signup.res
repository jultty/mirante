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

// Data models

module Response = {
  type t<'data, 'root>
  @send external json: t<'data, 'root> => promise<'data> = "json"
  @send external clone: t<'data, 'root> => promise<'root> = "clone"
}

type response = {
  status?: int,
  statusText?: string,
  url?: string,
  redirected?: bool,
  ok?: bool,
}

type response_body = {
  status?: int,
  email?: string,
  token?: string,
  error?: string,
}

@val @scope("globalThis")
external fetch: (string, 'params) => promise<Response.t<response_body, response>> = "fetch"

type credentials = { email: string, token: string }
type credentials_store = { mutable email: string, mutable token: string }
type sign_up_data = { email: string, password: string, }

@scope("JSON")
@val external parseCredentials: string => credentials = "parse"

@scope("JSON")
@val external stringifyCredentials: credentials => string = "stringify"

type response_store = {
  mutable response?: response,
  mutable json?: response_body,
}

// Status logic

let form: element = getElementById(doc, "account_creation_form")
let dialog: element = getElementById(doc, "user_dialog")

let sign_up_handler = async (event) => {
  preventDefault(event)
  dialog.innerText = Null.make("")

  let form_data = parseForm(object, parseFields(form))

  let post_options = { "method": "POST", "headers": { "Content-Type": "application/json" }, "body": JSON.stringifyAny(form_data), }

   let response_store: response_store = {}

   try {

     let r = await fetch("http://localhost:3031/rpc/signup", post_options)
     response_store.response = Some(await r->Response.clone)
     response_store.json = Some(await r->Response.json)

     Console.log(response_store.response)
     Console.log(response_store.json)

   } catch {
     | _ => {
       Console.log(Error("Erro na requisição"))
       dialog.innerText = Null.make("Erro na requisição")
       () // TODO: should exit the function here, does it?
     }
   }

   // try {
   //   if Nullable.getOr(response_store.response.status, 0) == 400 {
   //     dialog.innerText = "Requisição inválida. Os dados informados são válidos?"
   //     () // TODO: should exit the function here, does it?
   //   }
   //   else if (response.status == 200 || response.status == 201) {
   //     credentials_store.email = response_json.email
   //     credentials_store.password = response_json.password
   //   }
   // } catch {
   //   | _ => {
   //  Console.log(Error("Erro ao processar resposta"))
   //     dialog.innerText = Null.make("Erro ao processar resposta")
   //     () // TODO: should exit the function here, does it?
   //   }
   // }

}

addEventListener(form, "submit", sign_up_handler)
