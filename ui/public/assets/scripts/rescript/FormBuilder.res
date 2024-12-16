open BrowserTypes
open Browser

type field = Meta.field

let find_display_name:
  (~element: Meta.concrete_entity, ~entity: Meta.entity=?) => string =
  (~element: Meta.concrete_entity, ~entity: option<Meta.entity>=?): string => {

    let max_length = 30
    let error_reference = switch entity {
      | Some(entity) => "entity" ++ entity.display_name
      | None => `concrete entity with id ${element.database_id}`
    }

    let name = switch (element: Meta.concrete_entity) {
    | { name: name, _ } => name
    | { instruction: instruction, _ } =>
        "(" ++ element.database_id ++ ") " ++ instruction
    | { content: content, _ } =>
        "(" ++ element.database_id ++ ") " ++ content
    | _ => raise(Meta.IncompleteSchema(
      `[FormBuilder.update_table]` ++
      `Could not find a suitable name for ${error_reference}`))
    }

    if String.length(name) > max_length {
      String.slice(name, ~start=0, ~end=max_length) ++ "…"
    } else { name }

  }

let make_field = async (form, field: field) => {

  let label = makeElement("label")
  label.for_ = Some(field.id)
  label.innerText = field.label

  appendChild(form, label)
  appendChild(form, makeElement("br"))

  if field.kind == "select" {

    let relation_details = Option.getExn(field.relation_details,
      ~message=`[FormBuilder.make_field] Details not defined for select field ${field.id}`)

    let reference = Option.getExn(relation_details.reference,
      ~message=`[FormBuilder.make_field] Reference not defined for select field ${field.id}`)

    let get_options = Auth.make_get_options()

    let related = await fetchRelated(
      Meta.schema.system.constants.root_url ++ "/" ++ reference, get_options)
    let array = await related->Response.json

    let select = makeElement("select")
    select.id = Some(field.id)
    select.name = Some(field.id)

    Array.forEach(array, option => {

      let name = find_display_name(~element=option)

      let element = makeElement("option")
      element.value = Some(option.database_id)
      element.innerText = Some(name)
      appendChild(select, element)
    })

    appendChild(form, select)
    appendChild(form, makeElement("br"))

  } else {

    let input = makeElement("input")
    input.type_ = Some(field.kind)
    input.id = Some(field.id)
    input.name = Some(field.id)

    appendChild(form, input)
    appendChild(form, makeElement("br"))

  }
}

let make_submit_button = (form: element, text: string) => {

  let button = makeElement("input")
  button.type_ = Some("submit")
  button.value = Some(text)

  appendChild(form, button)

}

let make_form = async (fields: array<field>, id: string): element => {

  let form = makeElement("form")

  for i in 0 to Array.length(fields) - 1 {

    let field = Option.getExn(fields[i],
      ~message=`[FormBuilder.make_form]` ++
      `Field on index ${string_of_int(i)} should not be None`)

    await make_field(form, field)
  }

  make_submit_button(form, "Enviar")

  form.id = Some(id)
  form

}
