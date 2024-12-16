open Browser
open AuthTypes

@scope("JSON")
@val external parseCredentials: string => credentials = "parse"

@scope("JSON")
@val external stringifyCredentials: credentials => string = "stringify"

let getCredentialsOption = (): option<credentials> => {

  let stringifiedOpt: option<string> = retrieve(Meta.schema.system.constants.storage_key)

  switch stringifiedOpt {
  | Some(s) => Some(parseCredentials(s))
  | None => None
  }
}

let getCredentials = (): credentials => {
  let stringified = switch retrieve(Meta.schema.system.constants.storage_key) {
  | Some(credentials) => credentials
  | None => raise(CredentialsNotFound("[Auth.getToken] Browser.retrieve returned None"))
  }

  parseCredentials(stringified)
}
