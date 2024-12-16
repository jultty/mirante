open Browser
open BrowserTypes

// Page structure

// Listing table

let make_header_row = (entity: Meta.entity): BrowserTypes.element => {

  let headers = entity.view.table.headers
  let header_row = makeElement("tr")

  let checkbox_header = makeElement("th")
  checkbox_header.id = Some("checkbox_header")
  let select_all_checkbox = makeElement("input")
  select_all_checkbox.type_ = Some("checkbox")
  select_all_checkbox.id = Some("select_all_checkbox")
  appendChild(checkbox_header, select_all_checkbox)
  appendChild(header_row, checkbox_header)

  Array.forEach(headers, header => {
    let element = makeElement("th")
    element.id = Some(Meta.make_slug(TableHeader, entity))
    element.innerText = Some(header)
    appendChild(header_row, element)
  })

  let edit_header = makeElement("th")
  edit_header.id = Some("edit_header")
  edit_header.innerText = Some("Editar")
  appendChild(header_row, edit_header)

  header_row
}

let make_table = (entity: Meta.entity): BrowserTypes.element => {

  let div = makeElement("div")

  let header = makeElement("h2")
  header.innerText = Some(Util.to_sentence_title_case(
    switch entity.view.table.title {
    | Some(text) => text
    | None => entity.plural_display_name
    }
  ))
  appendChild(div, header)

  let table = makeElement("table")
  table.id = Some(Meta.make_slug(Table, entity))

  let header_row = make_header_row(entity)

  appendChild(table, header_row)
  appendChild(div, table)

  appendChild(div, makeElement("br"))

  let delete_button = makeElement("button")
  delete_button.id = Some("delete_button")
  delete_button.innerText = Some("Excluir selecionados")
  appendChild(div, delete_button)

  div

}

// Table logic

let reset_table = (entity: Meta.entity): () => {

  let table = getElement(Meta.make_slug(Table, entity), `${entity.slug} reset_table`)
  clearChildren(table)

  let header_row = make_header_row(entity)
  appendChild(table, header_row)

}

let update_table = async (entity: Meta.entity): () => {

  let table = getElement(Meta.make_slug(Table, entity), `${entity.slug} update_table`)
  let token = Auth.getCredentials().user_token
  let response_store: Meta.generic_response_store<'a> = {}

  let get_options = {
    "method": "GET",
    "headers": {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${token}`,
    },
  }

  reset_table(entity)

  let response = await fetch(Meta.make_endpoint(entity), get_options)

  response_store.response = Some(await response->BrowserTypes.Response.clone)
  response_store.array = Some(await response->BrowserTypes.Response.array)

  let array: array<Meta.concrete_entity> = switch response_store.array {
  | Some(found_array) => found_array
  | None => []
  }

  for i in 0 to Array.length(array) - 1 {

    let element = Option.getExn(array[i],
    ~message=`[View.update_table]
      Element on index ${string_of_int(i)} should not be None`)

    let row = makeElement("tr")

    let checkbox_cell = makeElement("td")
    let checkbox = makeElement("input")
    checkbox.type_ = Some("checkbox")
    checkbox.id = Some(`${entity.slug}_${element.database_id}_checkbox`)
    checkbox.class = Some("select_row_checkbox")
    appendChild(checkbox_cell, checkbox)
    appendChild(row, checkbox_cell)

    let name = Option.getOr(element.name, Option.getOr(
        element.instruction, "Item sem nome")
    )

    let name = if String.length(name) > 70 {
      String.slice(name, ~start=0, ~end=70) ++ "..."
    } else { name }

    let name_cell = makeElement("td")
    name_cell.innerText = Some(name)
    appendChild(row, name_cell)

    //

    if Option.isSome(entity.view.table.columns) {

      let columns = Option.getExn(entity.view.table.columns) // as checked above

      for i in 0 to Array.length(columns) - 1 {

        let column = Option.getExn(columns[i],
          ~message=`[View.update_table]
          Column on index ${string_of_int(i)} should not be None`)

        // Still adding kinds
        // Done: ForeignString

        if column.kind == ForeignString {

          let reference = Option.getExn(column.options.reference,
            ~message=`[View.update_table]
            Reference not defined for ForeignString column ${column.display_name}`)

          // TODO abstract further
          let object_of_record = (record: Meta.concrete_entity) => {
            Console.log(record)
            Option.getExn(record.set)
          }

          // TODO abstract further
          let relation_id = object_of_record(element)

          let get_options = Auth.make_get_options()

          let related = await fetchRelated(
            Meta.schema.system.constants.root_url ++ "/" ++ reference ++ "?id=eq." ++ string_of_int(relation_id), get_options)
          let array = await related->Response.json

          let found_relation = Option.getExn(array[0], ~message=`[View.update_table] First element in related response array not found`)

          let cell = makeElement("td")
          cell.innerText = found_relation.name
          appendChild(row, cell)

        }
      }
    }

    //

    let edit_cell = makeElement("td")
    let edit_button = makeElement("button")
    edit_button.innerText = Some("Editar")
    edit_button.id = Some(`${entity.slug}_${element.database_id}_edit_button`)
    edit_button.class = Some("edit_row_button")
    appendChild(edit_cell, edit_button)
    appendChild(row, edit_cell)

    appendChild(table, row)
  }
}

// Creation form

let make_creation_form = async (entity: Meta.entity): BrowserTypes.element => {

  let div = makeElement("div")
  let fields = entity.view.form.fields

  let header = makeElement("h2")
  header.innerText = Some(`Novo ${entity.display_name}`)
  appendChild(div, header)

  let form = await FormBuilder.make_form(fields, `${entity.slug}_creation_form`)
  appendChild(div, form)

  div

}

// Creation logic

type handler_options = { endpoint: string, entity_name: string, form_id: string, }

let make_creation_handler = (entity: Meta.entity): (BrowserTypes.event => promise<unit>)  => {

  let handler = async (event) => {
    preventDefault(event)

    let dialog: BrowserTypes.element = getElement(
      "user_dialog", `${entity.slug}.creation_handler.dialog`)

    let form: BrowserTypes.element = getElement(
      Meta.make_slug(CreationForm, entity),
      `${entity.slug}.creation_handler.form`
    )

    dialog.innerText = Some("")
    let form_data = parseForm(BrowserTypes.object, parseFields(form))
    let token = Auth.getCredentials().user_token

    let post_options = {
      "method": "POST",
      "headers": {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`,
      },
      "body": JSON.stringifyAny(form_data),
    }

    let response_store: Meta.generic_response_store<'a> = {}

     try {

       let response = await fetch(Meta.make_endpoint(entity), post_options)
       response_store.response = Some(await response->BrowserTypes.Response.clone)

     } catch {
       | error => {
         Console.log(error)
         dialog.innerText = Some("[${schema.entity_name}.creation_handler] Erro na requisição")
       }
     }

    try {

      let response = switch response_store.response {
        | Some(response) => response
        | None => { __client_error: `[${entity.slug} creation_handler] No response in response_store` }
      }

      let status = Option.getExn(response.status,
        ~message=`[${entity.slug} creation_handler.status] Destructuring error`)

      switch status {
      | 401 => {
          dialog.innerText =
            Some("Sua conta não possui acesso a este recurso")
        }
      | 400 | 403 => {
          dialog.innerText =
            Some("Requisição inválida. Os dados informados estão corretos?")
        }
      | 200 | 201 => {
        dialog.innerText = Some(`Criação de ${entity.display_name} feita com sucesso`)
        ignore( await update_table(entity) )
      }
      | value => Console.log(
        `[${entity.slug} creation_handler.status] Unexpected return status ${Int.toString(value)}`)
      }
    } catch {
       | error => {
         Console.log(error)
         dialog.innerText = Some("[${schema.entity_name}.creation_handler] Erro ao processar resposta")
       }
     }

  }

  handler
}

let make_nav_handler = (entity: Meta.entity): (BrowserTypes.event => promise<unit>) => {
  let event_handler = async (event: BrowserTypes.event) => {
    preventDefault(event)

    let credentials = Auth.getCredentialsOption()
    let dialog = getElement("user_dialog", `View.make_nav_handler dialog`)

    if Option.isSome(credentials) {

      let table = make_table(entity)
      let form = await make_creation_form(entity)

      submitListen(form, make_creation_handler(entity))

      let main = getElementByTag("main", `View.make_nav_handler main`)
      clearChildren(main)

      appendChild(main, table)
      appendChild(main, form)

      ignore( await update_table(entity) )

    } else {
      dialog.innerText = Some("Crie uma conta ou faça login primeiro")
    }
  }

  event_handler
}
