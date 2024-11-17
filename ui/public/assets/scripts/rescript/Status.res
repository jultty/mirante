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
external fetchVersion: (
  string,
  'params,
) => promise<Browser.Response.t<(version, _)>> =
  "fetch"
// Status logic

%%private(let status_object: status = { version: "", user: "", error: "" })

let setStatus = async () => {
  let fetch_options = { "method": "GET" }

  try {
    let response = await fetchVersion("http://localhost:3031/version?current=is.true", fetch_options)
    let response_json = await response->Browser.Response.json
    let (first_version, _) = response_json
    switch first_version.tag {
      | "" => status_object.error = "No version tag in response"
      | _ => status_object.version = "Mirante " ++ first_version.tag
      }
  } catch {
    | _ => Console.log(Error("Erro de conexão inesperado")) // TODO: concatenate actual error
  }

  // Authentication logic

  let stored_credentials = Browser.getItem(Browser.sessionStorage, "mirante_credentials")

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

  let status_element = Option.getExn(Browser.getElementById(Browser.doc, "status"), ~message="status_element not found")

  if status_object.error != "" {
    status_element.innerText = Some("Erro: " ++ status_object.error)
  } else if status_object.user != "" && status_object.version != "" {
    status_element.innerText = Some("Conectado: " ++ status_object.version ++ " " ++ status_object.user)
  } else if status_object.version != "" {
    status_element.innerText = Some("Conectado: " ++ status_object.version)
  }

}
