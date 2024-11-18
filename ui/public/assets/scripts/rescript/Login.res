open Browser
open Auth

// Populate form

let populate_form = () => {

  let main = getElementByTag("main", "Login.main")
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
  header.innerText = Some("Login")
  appendChild(main, header)

  let login_form = FormBuilder.make_form(fields, "login_form")
  appendChild(main, login_form)

}

// Login logic

let login_handler = async (event) => {
  preventDefault(event)

  let dialog: element = getElement("user_dialog", "Login.dialog")
  let login_form: element = getElement("login_form", "Login.login_form")

  dialog.innerText = Some("")

  let form_data = parseForm(object, parseFields(login_form))

  let post_options = {
    "method": "POST",
    "headers": { "Content-Type": "application/json" },
    "body": JSON.stringifyAny(form_data),
  }

   let response_store: response_store = {}

   try {

     let response = await fetch(Meta.endpoints.login, post_options)
     response_store.response = Some(await response->Response.clone)
     response_store.json = Some(await response->Response.json)

   } catch {
     | _ => {
       Console.log(Error("Erro na requisição"))
       dialog.innerText = Some("Erro na requisição")
     }
   }

  try {

    let response = switch response_store.response {
      | Some(response) => response
      | None => { __client_error: "" }
    }

    let status = Option.getExn(response.status,
      ~message="[Login.status] Destructuring error")

    switch status {
    | 400 | 403 => {
        dialog.innerText =
          Some("Requisição inválida. Os dados informados estão corretos?")
      }
    | 200 | 201 => {
        let json = Option.getExn(response_store.json,
          ~message="[Login.json] Destructuring error")

        let token = Option.getExn(json.token,
          ~message="[Login.token] Destructuring error")

        let credentials: credentials = {
          user_email: form_data["email"],
          user_token: token
        }

        let credentials_stringified: string =
          Option.getExn(JSON.stringifyAny(credentials))

        store(Meta.constants.storage_key, credentials_stringified)
        dialog.innerText = Some("Login realizado com sucesso")

        Console.log(
         JSON.stringifyAny(retrieve(storage, Meta.constants.storage_key)))
      }
    | value => Console.log(`Unexpected return status ${Int.toString(value)}`)
    }
  } catch {
     | _ => {
       Console.log(Error("Erro ao processar resposta"))
       dialog.innerText = Some("Erro ao processar resposta")
     }
   }

}

let structure = () => {

  populate_form()

  submitListen(
    getElement("login_form", "Login.addSubmitListener"),
    login_handler
  )
}
