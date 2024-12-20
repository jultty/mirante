// Data models

type version = { tag: string, error: string }

type credentials = AuthTypes.credentials

type status = {
  mutable version: string,
  mutable user: string,
  mutable error: string,
}

@val @scope("globalThis")
external fetchVersion: (string, 'params) =>
  promise<BrowserTypes.Response.t<array<version>, _, _>> = "fetch"

// Status logic

%%private(let status_object: status = { version: "", user: "", error: "" })

let setStatus = async (_: BrowserTypes.event) => {

  try {

    let response = await fetchVersion(
      Meta.schema.system.endpoints.version_current,
      { "method": "GET" }
    )

    let response_json: array<version> = await response->BrowserTypes.Response.json

    switch response_json[1] {
    | Some(_) => status_object.error = "More than one current version returned"
    | None => ()
    }

    switch response_json[0] {
    | Some(element) => status_object.version = "Mirante " ++ element.tag
    | None => status_object.error = "No current version returned"
  }

  } catch {
    | error => Console.log(error)
  }

  // Authentication logic

  try {
    switch Auth.getCredentialsOption() {
    | Some(credentials) => status_object.user = "[" ++ credentials.user_email ++ "]"
    | None => status_object.user = "[Não autenticado]"
    }
  } catch {
    | error => Console.log(error)
  }

  // Status message assembly logic

  let status_element = Browser.getElement("status", "Status.setStatus")

  if status_object.error != "" {
    status_element.innerText = Some("Erro: " ++ status_object.error)
  } else if status_object.user != "" && status_object.version != "" {
    status_element.innerText = Some("Conectado: " ++ status_object.version ++ " " ++ status_object.user)
  } else if status_object.version != "" {
    status_element.innerText = Some("Conectado: " ++ status_object.version)
  }

}
