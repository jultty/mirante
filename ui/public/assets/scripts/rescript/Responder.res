open BrowserTypes
open Browser

let make_set_selector = async (): element => {

  let get_options = Auth.make_get_options()

  let related = await fetchRelated(
    Meta.schema.system.constants.root_url ++ "/" ++
    Meta.schema.entity.exercise_set.slug, get_options)
  let array = await related->Response.json

  let select = makeElement("select")
  select.id = Some("set_selector")
  select.name = Some("set_selector")

  let empty_option = makeElement("option")
  empty_option.value = Some("placeholder")
  empty_option.innerText = Some("Selecione um conjunto de exercícios")
  appendChild(select, empty_option)

  Array.forEach(array, set => {
    let option = makeElement("option")
    option.value = set.id
    option.innerText = set.name
    appendChild(select, option)
  })

  select
}

let submit_handler = async (event) => {
  preventDefault(event)

  let dialog: element = getElement("user_dialog", "Responder.dialog")
  let response_form: element = getElement("response_form", "Responder.submit_handler")

  let token = Auth.getCredentials().user_token

  let response_store: BrowserTypes.response_store<'a> = {}
  dialog.innerText = Some("")

  let form_children: array<element> = Option.getExn(response_form.children, ~message="TODO")
  let chosen_options: array<element> = []

  // TODO a dedicated data structure could eliminate this cursed arrow looping
  for i in 0 to Array.length(form_children) - 1 {
    let child = Option.getExn(form_children[i], ~message="TODO")
    if Option.getExn(child.nodeName, ~message="TODO") == "FIELDSET" {
      let fieldset_children: array<element> = Option.getExn(child.children)
      for i in 0 to Array.length(fieldset_children) - 1 {
        let child = Option.getExn(fieldset_children[i], ~message="TODO")
        if Option.getExn(child.nodeName) == "P" {
          let options: array<element> = Option.getExn(child.children)
          for i in 0 to Array.length(options) - 1 {
            let option = Option.getExn(options[i])
            if Option.isSome(option.type_) {
              if Option.getExn(option.type_) == "radio" &&
              Option.getExn(option.checked, ~message="TODO") {
                Console.log(option)
                Array.push(chosen_options, option)
              }
            }
          }
        }
      }
    }
  }

    let total = Array.length(chosen_options)

   try {

    for i in 0 to total - 1 {
      let option = Option.getExn(chosen_options[i],
        ~message=`[Responder.submit_handler] Option on index ${string_of_int(i)} is None`)

      let body = {
        "option": option.value
        // TODO: place field
      }

      let post_options = {
        "method": "POST",
        "headers": {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`,
      },
        "body": JSON.stringifyAny(body),
      }

      let response = await fetch(
        Meta.make_endpoint(Meta.schema.entity.response), post_options)
      response_store.response = Some(await response->Response.clone)

      Console.log(response_store.response)

    }

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
      ~message="[Responder.status] Destructuring error")

    switch status {
    | 400 | 403 => {
        dialog.innerText =
          Some("Requisição inválida. Os dados informados estão corretos?")
      }
    | 200 | 201 => {

        dialog.innerText = Some("Respostas enviadas com sucesso")

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

let populate_form = async (id: string): unit => {
  let old_form = getElement("response_form", "Responder.structure")
  let new_form = makeElement("form")
  new_form.id = Some("response_form")
  new_form.action = Some(Meta.schema.system.constants.root_url ++ "/" ++
    Meta.schema.entity.response.slug)
  new_form.method = Some("POST")

  let get_options = Auth.make_get_options()

  let url = Meta.schema.system.constants.root_url ++ "/" ++
    Meta.schema.entity.exercise.slug ++ `?set=eq.${id}`

  let related = await fetchRelated(url, get_options)
  let exercises = await related->Response.json

  for i in 0 to Array.length(exercises) - 1 {
    let exercise: Meta.concrete_entity = Option.getExn(exercises[i],
      ~message=`[Responder.populate_form] Could not find exercise on id ${string_of_int(i)}`)

    let fieldset = makeElement("fieldset")
    let legend = makeElement("legend")
    legend.innerText = Some(Option.getExn(exercise.instruction,
      ~message="[Responder.submit_handler] Exercise with database id " ++
      exercise.database_id ++ " does not have an instruction"))
    appendChild(fieldset, legend)

    let url = Meta.schema.system.constants.root_url ++ "/" ++
      Meta.schema.entity.option.slug ++ `?exercise=eq.${exercise.database_id}`
    let related = await fetchRelated(url, get_options)
    let options: array<Meta.concrete_entity> = await related->Response.json

    for i in 0 to Array.length(options) - 1 {
      let option = Option.getExn(options[i],
        ~message=`[Responder.populate_form] Could not find option on id ${string_of_int(i)}`)
      let id = `exercise_${exercise.database_id}_option_${option.database_id}`
      let radio_wrapper = makeElement("p")
      let input = makeElement("input")
      input.type_ = Some("radio")
      input.value = Some(option.database_id)
      input.id = Some(id)
      let label = makeElement("label")
      label.innerText = Some(Option.getExn(option.content,
        ~message="[Responder.submit_handler] Option with database id " ++
        option.database_id ++ " does not have content"))
      label.for_ = Some(id)

      appendChild(radio_wrapper, input)
      appendChild(radio_wrapper, label)
      appendChild(fieldset, radio_wrapper)
    }

    appendChild(new_form, fieldset)
  }

  let button = makeElement("input")
  button.type_ = Some("submit")
  button.value = Some("Enviar")
  appendChild(new_form, button)

  replace(old_form, new_form)
  submitListen(
    getElement("response_form", "Responder.structure"),
    submit_handler
  )
}

let set_selection_handler = async (_): unit => {
  let selector = getElement(
    "set_selector", "Responder.set_selection_handler")
  await populate_form(Option.getExn(selector.value))
}

let structure = async (_: BrowserTypes.event): unit => {

  let main = getElementByTag("main", "Responder.structure")
  clearChildren(main)

  let header = makeElement("h2")
  header.innerText = Some("Responder exercícios")
  appendChild(main, header)

  let set_selector = await make_set_selector()
  let form = makeElement("form")
  form.id = Some("response_form")

  appendChild(main, set_selector)
  appendChild(main, form)

  changeListen(
    getElement("set_selector", "Responder.structure"),
    set_selection_handler
  )
}
