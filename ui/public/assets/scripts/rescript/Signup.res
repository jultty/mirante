open BrowserTypes
open Browser

// Populate form

let populate_form = () => {

  let main = getElementByTag("main", "Signup.main")
  clearChildren(main)

  let fields: array<FormBuilder.field> = [
    {
      id: "email",
      kind: "email",
      label: "Email:",
    },
    {
      id: "password",
      kind: "password",
      label: "Senha:",
    },
  ]

  let header = makeElement("h2")
  header.innerText = Some("Criar conta")
  appendChild(main, header)

  let signup_form = FormBuilder.make_form(fields, "signup_form")
  appendChild(main, signup_form)

}

// Signup logic

let signup_handler = async (event) => {
  preventDefault(event)

  let dialog: element = getElement("user_dialog", "Signup.dialog")
  let signup_form: element = getElement("signup_form", "Signup.signup_form")

  dialog.innerText = Some("")

  let form_data = parseForm(object, parseFields(signup_form))

  let post_options = {
    "method": "POST",
    "headers": { "Content-Type": "application/json" },
    "body": JSON.stringifyAny(form_data),
  }

   let response_store: BrowserTypes.response_store<'a> = {}

   try {

     let response = await fetch(Meta.schema.system.endpoints.signup, post_options)
     response_store.response = Some(await response->Response.clone)
     response_store.json = Some(await response->Response.json)

     Console.log(response_store.response)
     Console.log(response_store.json)

   } catch {
     | error => {
       Console.log(error)
       dialog.innerText = Some("Erro na requisição")
     }
   }

  try {

    let response = switch response_store.response {
      | Some(response) => response
      | None => { __client_error: "" }
    }

    let status = Option.getExn(response.status,
      ~message="[Signup.status] Destructuring error")

    switch status {
    | 400 | 403 => {
        dialog.innerText =
          Some("Requisição inválida. Os dados informados estão corretos?")
      }
    | 409 => {
        dialog.innerText = Some("Já existe uma conta com este email")
      }
    | 200 | 201 => {
        let json = Option.getExn(response_store.json,
          ~message="[Signup.json] Destructuring error")

        let email = Option.getExn(json.email,
          ~message="[Signup.email] Destructuring error")

        let token = Option.getExn(json.token,
          ~message="[Signup.token] Destructuring error")

        let credentials: AuthTypes.credentials = { user_email: email, user_token: token }

        let credentials_stringified: string =
          Option.getExn(JSON.stringifyAny(credentials))

        store(Meta.schema.system.constants.storage_key, credentials_stringified)
        dialog.innerText = Some("Conta criada com sucesso")

        Console.log(
         JSON.stringifyAny(retrieve(Meta.schema.system.constants.storage_key)))
      }
    | value => Console.log(`Unexpected return status ${Int.toString(value)}`)
    }
  } catch {
     | error => {
       Console.log(error)
       dialog.innerText = Some("Erro ao processar resposta")
     }
   }

}

let structure = async (_: BrowserTypes.event) => {

  populate_form()

  submitListen(
    getElement("signup_form", "Signup.addSubmitListener"),
    signup_handler
  )
}
