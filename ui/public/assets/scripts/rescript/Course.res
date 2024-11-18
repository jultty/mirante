open Browser
open Auth

// Page structure

// Listing table

let make_header_row = (): element => {

  let header_row = makeElement("tr")

  let checkbox_header = makeElement("th")
  checkbox_header.id = Some("checkbox_header")
  let select_all_checkbox = makeElement("input")
  select_all_checkbox.type_ = Some("checkbox")
  select_all_checkbox.id = Some("select_all_checkbox")
  appendChild(checkbox_header, select_all_checkbox)
  appendChild(header_row, checkbox_header)

  let course_name_header = makeElement("th")
  course_name_header.id = Some("course_name_header")
  course_name_header.innerText = Some("Nome")
  appendChild(header_row, course_name_header)

  let edit_header = makeElement("th")
  edit_header.id = Some("edit_header")
  edit_header.innerText = Some("Editar")
  appendChild(header_row, edit_header)

  header_row
}

let make_listing_table = (): element => {

  let div = makeElement("div")

  let header = makeElement("h2")
  header.innerText = Some("Cursos")
  appendChild(div, header)

  let table = makeElement("table")
  table.id = Some("course_table")

  let header_row = make_header_row()

  appendChild(table, header_row)
  appendChild(div, table)

  let delete_button = makeElement("button")
  delete_button.id = Some("delete_button")
  delete_button.innerText = Some("Excluir selecionados")
  appendChild(div, delete_button)

  div

}

// Table logic

let reset_table = (): () => {

  let table = getElement("course_table", "Course.reset_table")
  clearChildren(table)

  let header_row = make_header_row()
  appendChild(table, header_row)

}

let update_table = async (): () => {

  let table = getElement("course_table", "Course.update_table")
  let token = Auth.getCredentials().user_token
  let response_store: response_store = {}

  let get_options = {
    "method": "GET",
    "headers": {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${token}`,
    },
  }

  reset_table()

  let response = await fetch(Meta.endpoints.course, get_options)

  response_store.response = Some(await response->Response.clone)
  response_store.array = Some(await response->Response.array)

  let array = switch response_store.array {
  | Some(a) => a
  | None => []
  }

  Array.forEach(array, course => {

    let row = makeElement("tr")

    let checkbox_cell = makeElement("td")
    let checkbox = makeElement("input")
    checkbox.type_ = Some("checkbox")
    checkbox.id = Some(`course_${course.id}_checkbox`)
    checkbox.class = Some("course_checkbox")
    appendChild(checkbox_cell, checkbox)
    appendChild(row, checkbox_cell)

    let name_cell = makeElement("td")
    name_cell.innerText = course.name
    appendChild(row, name_cell)

    let edit_cell = makeElement("td")
    let edit_button = makeElement("button")
    edit_button.innerText = Some("Editar")
    edit_button.id = Some(`course_${course.id}_edit_button`)
    edit_button.class = Some("course_edit_button")
    appendChild(edit_cell, edit_button)
    appendChild(row, edit_cell)

    appendChild(table, row)
  })

}

// Creation form

let make_creation_form = (): element => {

  let div = makeElement("div")

  let fields: array<FormBuilder.field> = [
    {
      id: "name",
      kind: "text",
      label: "Nome:",
    },
  ]

  let header = makeElement("h2")
  header.innerText = Some("Novo curso")
  appendChild(div, header)

  let form = FormBuilder.make_form(fields, "course_creation_form")
  appendChild(div, form)

  div

}

// Creation logic

let creation_handler = async (event) => {
  preventDefault(event)

  let dialog: element = getElement("user_dialog", "Course.creation_handler.dialog")
  let form: element = getElement("course_creation_form", "Course.creation_handler.form")

  dialog.innerText = Some("")

  let form_data = parseForm(object, parseFields(form))

  let token = Auth.getCredentials().user_token

  let post_options = {
    "method": "POST",
    "headers": {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${token}`,
    },
    "body": JSON.stringifyAny(form_data),
  }

   let response_store: response_store = {}

   try {

     let response = await fetch(Meta.endpoints.course, post_options)
     response_store.response = Some(await response->Response.clone)

   } catch {
     | error => {
       Console.log(error)
       dialog.innerText = Some("Erro na requisição")
     }
   }

  try {

    let response = switch response_store.response {
      | Some(response) => response
      | None => { __client_error: "[Course.creation_handler] No response in response_store" }
    }

    let status = Option.getExn(response.status,
      ~message="[Course.creation_handler.status] Destructuring error")

    switch status {
    | 401 => {
        dialog.innerText =
          Some("Sua conta não possui acesso a esse recurso")
      }
    | 400 | 403 => {
        dialog.innerText =
          Some("Requisição inválida. Os dados informados estão corretos?")
      }
    | 200 | 201 => {
      dialog.innerText = Some("Curso criado com sucesso")
      ignore( await update_table() )
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

let structure = async () => {

  let credentials = Auth.getCredentialsOption()
  let dialog = getElement("user_dialog", "Course.structure")

  if Option.isSome(credentials) {

    let table = make_listing_table()
    let form = make_creation_form()

    submitListen(form, creation_handler)

    let main = getElementByTag("main", "Course.structure.main")
    clearChildren(main)

    appendChild(main, table)
    appendChild(main, form)

    ignore( await update_table() )

  } else {
    dialog.innerText = Some("Crie uma conta ou faça login primeiro")
  }
}
