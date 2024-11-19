open BrowserTypes
open Browser

type form_data = { "email": string, "password": string }

type fields
@new external parseFields: element => object = "FormData"
@send external parseForm: (object, object) => form_data = "fromEntries"

type credentials = {
  @as("email") user_email: string,
  @as("token") user_token: string
}

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
