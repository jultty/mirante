type document
type window
type sessionStorage
type credentials = { email: string, token: string }
type rec element = { mutable innerText: Js.null<string> }

// Interop bindings

@val external doc: document = "document"
@send external getElementById: (document, string) => element = "getElementById"

@val external sessionStorage: sessionStorage = "sessionStorage"
@send external getItem: (sessionStorage, string) => string = "getItem"

@val external window: window = "window"
@send external addEventListener: (window, string, 'a => promise<unit>) => unit = "addEventListener"

module Response = {
  type t<'data>
  @send external json: t<'data> => promise<'data> = "json"
}

@scope("JSON")
@val external parseCredentials: string => credentials = "parse"

// Data models

type version = { tag: string, error: string }

@val @scope("globalThis")
external fetch: (
  string,
  'params,
) => promise<Response.t<(version, _)>> =
  "fetch"

type status = {
  mutable version: string,
  mutable user: string,
  mutable error: string,
}

// Status logic

let status_object: status = { version: "", user: "", error: "" }

let setStatus = async (_) => {
  let fetch_options = { "method": "GET" }

  try {
    let response = await fetch("http://localhost:3031/version?current=is.true", fetch_options)
    let response_json = await response->Response.json
    let (first_version, _) = response_json
    Console.log(first_version)
    switch first_version.tag {
      | "" => status_object.error = "No version tag in response"
      | _ => status_object.version = "Mirante " ++ first_version.tag
      }
  } catch {
    | _ => Console.log(Error("Erro de conexão inesperado")) // TODO: concatenate actual error
  }

  // Authentication logic

  let stored_credentials = getItem(sessionStorage, "mirante_credentials")

  try {
    if Js.testAny(stored_credentials) {
      status_object.user = "[Não autenticado]"
    } else {
      let credentials_json = parseCredentials(stored_credentials)
      status_object.user = "[" ++ credentials_json.email ++ "]"
    }
  } catch {
    | _ => Console.log(Error("Erro de conexão inesperado")) // TODO: concatenate actual error
  }

  // Status message assembly logic

  let status_element: element = getElementById(doc, "status")

  if status_object.error != "" {
    status_element.innerText = Null.make("Erro: " ++ status_object.error)
  } else if status_object.user != "" && status_object.version != "" {
    status_element.innerText = Null.make("Conectado: " ++ status_object.version ++ " " ++ status_object.user)
  } else if status_object.version != "" {
    status_element.innerText = Null.make("Conectado: " ++ status_object.version)
  }

}

addEventListener(window, "load", setStatus)
