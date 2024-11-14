// Interop bindings

type document
type form
type event
type object
type sessionStorage
type form_data = { "email": string, "password": string }
type rec element = { mutable innerText: Js.null<string> }

@val external doc: document = "document"
@val external object: object = "Object"
@val external storage: sessionStorage = "sessionStorage"

@send external getElementById: (document, string) => element = "getElementById"
@send external addEventListener: (element, string, 'a => promise<unit>) => unit = "addEventListener"
@send external preventDefault: (event) => unit = "preventDefault"
@send external store: (sessionStorage, string, string) => () = "setItem"
@send external retrieve: (sessionStorage, string, string) => () = "getItem"

type fields
@new external parseFields: element => object = "FormData"
@send external parseForm: (object, object) => form_data = "fromEntries"

@val external sessionStorage: sessionStorage = "sessionStorage"
@send external getItem: (sessionStorage, string) => string = "getItem"

// Data models

module Response = {
  type t<'body, 'request>
  @send external json: t<'body, 'request> => promise<'body> = "json"
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

type credentials = { email: string, token: string }
type credentials_store = { mutable email: string, mutable token: string }

@scope("JSON")
@val external parseCredentials: string => credentials = "parse"

@scope("JSON")
@val external stringifyCredentials: credentials => string = "stringify"

type response_store = {
  mutable response?: response,
  mutable json?: response_body,
}

// Dependent interop bindings

@val @scope("globalThis")
external fetch: (string, 'params) => promise<Response.t<response_body, response>> = "fetch"

// Login logic

let form: element = getElementById(doc, "login_form")
let dialog: element = getElementById(doc, "user_dialog")

let login_handler = async (event) => {
  preventDefault(event)
  dialog.innerText = Null.make("")

  let form_data = parseForm(object, parseFields(form))

  let post_options = {
    "method": "POST",
    "headers": { "Content-Type": "application/json" },
    "body": JSON.stringifyAny(form_data),
  }

   let response_store: response_store = {}

   try {

     let response = await fetch("http://localhost:3031/rpc/login", post_options)
     response_store.response = Some(await response->Response.clone)
     response_store.json = Some(await response->Response.json)

     Console.log(response_store.response)
     Console.log(response_store.json)

   } catch {
     | _ => {
       Console.log(Error("Erro na requisição"))
       dialog.innerText = Null.make("Erro na requisição")
       () // TODO: should exit the function here, does it?
     }
   }

   try {

     // TODO
     // this destructuring with switches is a pattern that can be extracted to common.res
     // this syntax avoids Caml_option imports, which are not supported in the browser

     let response = switch response_store.response {
        | Some(response) => response
        | None => { __client_error: "" }
      }

      let status = switch response.status {
        | Some(status) => status
        | None => -1 // TODO: replace magic number with variant
      }

      let json = switch response_store.json {
        | Some(json) => json
        | None => { __client_error: "json function not found while destructuring object" }
      }

      let email = form_data["email"]

      let token = switch json.token {
        | Some(token) => token
        | None => { Console.log("Token field not found while destructuring") ; ""}
      }

      let credentials: credentials = { email: email, token: token }
      let credentials_stringified: string = switch JSON.stringifyAny(credentials) {
        | Some(string) => string
        | None => ""
      }

      Console.log("response_store.json:")
      Console.log(json)

     if status == 400 {
       dialog.innerText = Null.make("Requisição inválida. Os dados informados são válidos?")
       () // TODO: should exit the function here, does it?
     } else if status == 403 || status == 403 {
       dialog.innerText = Null.make("Credenciais inválidas: senha incorreta ou email inexistente")
       () // TODO: should exit the function here, does it?
      } else if status == 200 || status == 201 {
        Console.log(JSON.stringifyAny(credentials))
        store(storage, "mirante_credentials", credentials_stringified)
        dialog.innerText = Null.make("Login realizado com sucesso")
        () // TODO: should exit the function here, does it?
     }
   } catch {
     | _ => {
    Console.log(Error("Erro ao processar resposta"))
       dialog.innerText = Null.make("Erro ao processar resposta")
       () // TODO: should exit the function here, does it?
     }
   }

}

addEventListener(form, "submit", login_handler)
