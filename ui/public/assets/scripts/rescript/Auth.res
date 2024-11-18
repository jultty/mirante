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
