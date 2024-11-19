type window
@val external window: window = "window"

type document
@val external doc: document = "document"

type sessionStorage
@val external storage: sessionStorage = "sessionStorage"

type object
@val external object: object = "Object"

type form
type event

type rec element = {
  mutable innerText?: string,
  mutable href?: string,
  mutable id?: string,
  mutable class?: string,
  mutable name?: string,
  mutable value?: string,
  lastElementChild?: element,
  mutable onclick?: event => promise<unit>,
  @as("for") mutable for_?: string,
  @as("type") mutable type_?: string,
  children?: array<element>,
}

module Response = {
  type t<'data, 'request, 'entity>
  @send external json: t<'data, 'request, _> => promise<'data> = "json"
  @send external clone: t<'body, 'request, _> => promise<'root> = "clone"
  @send external array: t<'data, 'request, 'entity> => promise<array<'entity>> = "json"
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

type response_store<'a> = {
  mutable response?: response,
  mutable json?: response_body,
  mutable array?: array<'a>
}
