open BrowserTypes
open Browser

let populate_form = async () => {

  let main = getElementByTag("main", "Metrics.main")
  clearChildren(main)

  let fields: array<FormBuilder.field> = [
    {
      id: "period_from",
      kind: "date",
      label: "Data de início:",
    },
    {
      id: "period_to",
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

  let token = Auth.getCredentials().user_token

  let post_options = {
    "method": "POST",
    "headers": {
    "Content-Type": "application/json",
    "Authorization": `Bearer ${token}`,
  },
    "body": JSON.stringifyAny(form_data),
  }


    Console.log(post_options)
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
      switch response_store.json {
      | Some({ code: "P0001", message: "Nenhuma resposta encontrada no período", _ }) =>
        dialog.innerText = Some("Nenhuma resposta encontrada no período especificado")
      | _ => dialog.innerText =
        Some("Requisição inválida. Os dados informados estão corretos?")
      }
    }
    | 200 => {
      let metrics = switch response_store.json {
        | Some({ metrics: metrics, _ }) => metrics
        | _ => raise (Browser.UnexpectedResponseStructure(
          "200 rpc/metrics response does not contain a metrics object"))
      }
      dialog.innerText = Some(
        `Precisão: ${Float.toString(metrics.accuracy.index)}` ++
        ` (${Float.toString(metrics.accuracy.correct)} corretas /` ++
        ` ${Float.toString(metrics.accuracy.total)} total)` ++
        `\nAssiduidade: ${Float.toPrecision(metrics.assiduity.index, ~digits=3)}` ++
        ` (intensidade ${Float.toPrecision(metrics.assiduity.intensity, ~digits=2)}` ++
        ` + distribuição ${Float.toPrecision(metrics.assiduity.spread, ~digits=2)})` ++
        `\nPesos: Intensidade = 25%, Distribuição = 75%\n` ++
        Float.toFixed(metrics.assiduity.days_with_responses, ~digits=1) ++
        ` dias com respostas de um total de ` ++
        `${Float.toFixed(metrics.assiduity.total_days, ~digits=1)} dias.` ++
        if metrics.assiduity.total_days < 30.0 {
          `\nAtenção: O intervalo é curto demais para ser significativo!` }  else { `` }


      )

    }
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
