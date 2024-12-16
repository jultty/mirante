open BrowserTypes
open Browser

type field = Meta.field

@val @scope("globalThis")
external fetchRelated: (string, 'params) =>
  promise<BrowserTypes.Response.t<array<'a>, _, _>> = "fetch"

let make_field = async (form, field: field) => {

  let label = makeElement("label")
  label.for_ = Some(field.id)
  label.innerText = field.label

  appendChild(form, label)
  appendChild(form, makeElement("br"))

  if field.kind == "select" {

    let options = Option.getExn(field.options,
      ~message=`[FormBuilder.make_field] Options not defined for select field ${field.id}`)

    let reference = Option.getExn(options.reference,
      ~message=`[FormBuilder.make_field] Reference not defined for select field ${field.id}`)

    let get_options = Auth.make_get_options()

    let related = await fetchRelated(
      Meta.schema.system.constants.root_url ++ "/" ++ reference, get_options)
    let array = await related->Response.json

    let select = makeElement("select")
    select.id = Some(field.id)
    select.name = Some(field.id)

    Array.forEach(array, option => {
      let element = makeElement("option")
      element.value = Some(option["id"])
      element.innerText = Some(option["name"])
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
      ~message=`[FormBuilder.make_form] Field on index ${string_of_int(i)} should not be None`)

    await make_field(form, field)
  }

  make_submit_button(form, "Enviar")

  form.id = Some(id)
  form

}