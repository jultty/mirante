// Data models

type version = { tag: string, error: string }

type credentials = { email: string, token: string }
@scope("JSON") @val external parseCredentials: string => credentials = "parse"

type status = {
  mutable version: string,
  mutable user: string,
  mutable error: string,
}

@val @scope("globalThis")
external fetchVersion: (string, 'params) =>
  promise<Browser.Response.t<array<version>, _>> = "fetch"

// Status logic

%%private(let status_object: status = { version: "", user: "", error: "" })

let setStatus = async (_: Browser.event) => {

  try {
    // TODO Extract URL
    let url = Meta.endpoints.current_version
    let response = await fetchVersion(url, { "method": "GET" })
    let response_json: array<version> = await response->Browser.Response.json

    switch response_json[1] {
    | Some(_) => status_object.error = "More than one current version returned"
    | None => ()
    }

    switch response_json[0] {
    | Some(element) => status_object.version = "Mirante " ++ element.tag
    | None => status_object.error = "No current version returned"
  }

  } catch {
    | _ => Console.log(Error("Erro de conexão inesperado")) // TODO: concatenate actual error
  }

  // Authentication logic

  let stored_credentials = Browser.retrieve(
    Browser.storage, Meta.constants.storage_key)

  Console.log(stored_credentials)

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

  let status_element = Option.getExn(
    Browser.getElementById(Browser.doc, "status"),
    ~message="status_element not found"
  )

  if status_object.error != "" {
    status_element.innerText = Some("Erro: " ++ status_object.error)
  } else if status_object.user != "" && status_object.version != "" {
    status_element.innerText = Some("Conectado: " ++ status_object.version ++ " " ++ status_object.user)
  } else if status_object.version != "" {
    status_element.innerText = Some("Conectado: " ++ status_object.version)
  }

}
