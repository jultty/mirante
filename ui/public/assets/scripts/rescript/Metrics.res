open BrowserTypes
open Browser

let populate_form = async () => {

  let main = getElementByTag("main", "Metrics.main")
  clearChildren(main)

  let fields: array<FormBuilder.field> = [
    {
      id: "from",
      kind: "date",
      label: "Data de início:",
    },
    {
      id: "to",
      kind: "date",
      label: "Data final:",
    },
    {
      id: "store",
      kind: "checkbox",
      label: "Armazenar no servidor:",
    },
  ]

  let header = makeElement("h2")
  header.innerText = Some("Métricas")
  appendChild(main, header)

  let metrics_form = await FormBuilder.make_form(fields, "metrics_form")
  appendChild(main, metrics_form)

}

let submit_handler = async (event) => {
  preventDefault(event)

  let dialog: element = getElement("user_dialog", "Metrics.dialog")
  let metrics_form: element = getElement("metrics_form", "Metrics.metrics_form")

  dialog.innerText = Some("")

  let form_data = parseForm(object, parseFields(metrics_form))
  Console.log(form_data)

  let post_options = {
    "method": "POST",
    "headers": { "Content-Type": "application/json" },
    "body": JSON.stringifyAny(form_data),
  }

   let response_store: BrowserTypes.response_store<'a> = {}

   try {

    let url = Meta.schema.system.constants.root_url ++ "/rpc/metrics"
     let response = await fetch(url, post_options)
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
      ~message="[Metrics.status] Destructuring error")

    switch status {
    | 400 | 403 => {
      dialog.innerText =
      Some("Requisição inválida. Os dados informados estão corretos?")
    }
    | 200 => dialog.innerText = Some("Métrica calculada com sucesso")
    | 201 => dialog.innerText = Some("Métrica calculada e armazenada com sucesso")
    | value => Console.log(`Unexpected return status ${Int.toString(value)}`)
    }
  } catch {
     | error => {
       Console.log(error)
       dialog.innerText = Some("Erro ao processar resposta")
     }
   }

}

let structure = async (_: BrowserTypes.event): unit => {

  await populate_form()

  submitListen(
    getElement("metrics_form", "Metrics.addSubmitListener"),
    submit_handler
  )
}
