// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Auth from "./Auth.res.mjs";
import * as Meta from "./Meta.res.mjs";
import * as Browser from "./Browser.res.mjs";
import * as FormBuilder from "./FormBuilder.res.mjs";
import * as Core__Option from "@rescript/core/src/Core__Option.res.mjs";
import * as Caml_js_exceptions from "rescript/lib/es6/caml_js_exceptions.js";

async function populate_form() {
  var main = Browser.getElementByTag("main", "Metrics.main");
  Browser.clearChildren(main);
  var fields = [
    {
      id: "period_from",
      type: "date",
      label: "Data de início:"
    },
    {
      id: "period_to",
      type: "date",
      label: "Data final:"
    },
    {
      id: "store",
      type: "checkbox",
      label: "Armazenar no servidor:"
    }
  ];
  var header = Browser.makeElement("h2");
  header.innerText = "Métricas";
  main.appendChild(header);
  var metrics_form = await FormBuilder.make_form(fields, "metrics_form");
  main.appendChild(metrics_form);
}

async function submit_handler($$event) {
  $$event.preventDefault();
  var dialog = Browser.getElement("user_dialog", "Metrics.dialog");
  var metrics_form = Browser.getElement("metrics_form", "Metrics.metrics_form");
  dialog.innerText = "";
  var form_data = Object.fromEntries(new FormData(metrics_form));
  console.log(form_data);
  var token = Auth.getCredentials().token;
  var post_options = {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: "Bearer " + token
    },
    body: JSON.stringify(form_data)
  };
  console.log(post_options);
  var response_store = {};
  try {
    var url = Meta.schema.system.constants.root_url + "/rpc/metrics";
    var response = await globalThis.fetch(url, post_options);
    response_store.response = await response.clone();
    response_store.json = await response.json();
    console.log(response_store.response);
    console.log(response_store.json);
  }
  catch (raw_error){
    var error = Caml_js_exceptions.internalToOCamlException(raw_error);
    console.log(error);
    dialog.innerText = "Erro na requisição";
  }
  try {
    var response$1 = response_store.response;
    var response$2 = response$1 !== undefined ? response$1 : ({
          __client_error: ""
        });
    var status = Core__Option.getExn(response$2.status, "[Metrics.status] Destructuring error");
    var exit = 0;
    if (status >= 400) {
      exit = status !== 403 && status >= 401 ? 1 : 2;
    } else if (status !== 200) {
      if (status === 201) {
        dialog.innerText = "Métrica calculada e armazenada com sucesso";
        return ;
      }
      exit = 1;
    } else {
      var match = response_store.json;
      var metrics;
      if (match !== undefined) {
        var metrics$1 = match.metrics;
        if (metrics$1 !== undefined) {
          metrics = metrics$1;
        } else {
          throw {
                RE_EXN_ID: Browser.UnexpectedResponseStructure,
                _1: "200 rpc/metrics response does not contain a metrics object",
                Error: new Error()
              };
        }
      } else {
        throw {
              RE_EXN_ID: Browser.UnexpectedResponseStructure,
              _1: "200 rpc/metrics response does not contain a metrics object",
              Error: new Error()
            };
      }
      dialog.innerText = "Precisão: " + metrics.accuracy.index.toString() + (" (" + metrics.accuracy.correct.toString() + " corretas /") + (" " + metrics.accuracy.total.toString() + " total)") + ("\nAssiduidade: " + metrics.assiduity.index.toPrecision(3)) + (" (intensidade " + metrics.assiduity.intensity.toPrecision(2)) + (" + distribuição " + metrics.assiduity.spread.toPrecision(2) + ")") + "\nPesos: Intensidade = 25%, Distribuição = 75%\n" + metrics.assiduity.days_with_responses.toFixed(1) + " dias com respostas de um total de " + (metrics.assiduity.total_days.toFixed(1) + " dias.") + (
        metrics.assiduity.total_days < 30.0 ? "\nAtenção: O intervalo é curto demais para ser significativo!" : ""
      );
      return ;
    }
    switch (exit) {
      case 1 :
          console.log("Unexpected return status " + status.toString());
          return ;
      case 2 :
          var match$1 = response_store.json;
          if (match$1 === undefined) {
            dialog.innerText = "Requisição inválida. Os dados informados estão corretos?";
            return ;
          }
          var match$2 = match$1.code;
          if (match$2 === undefined) {
            dialog.innerText = "Requisição inválida. Os dados informados estão corretos?";
            return ;
          }
          if (match$2 !== "P0001") {
            dialog.innerText = "Requisição inválida. Os dados informados estão corretos?";
            return ;
          }
          var match$3 = match$1.message;
          if (match$3 === "Nenhuma resposta encontrada no período") {
            dialog.innerText = "Nenhuma resposta encontrada no período especificado";
          } else {
            dialog.innerText = "Requisição inválida. Os dados informados estão corretos?";
          }
          return ;
      
    }
  }
  catch (raw_error$1){
    var error$1 = Caml_js_exceptions.internalToOCamlException(raw_error$1);
    console.log(error$1);
    dialog.innerText = "Erro ao processar resposta";
    return ;
  }
}

async function structure(param) {
  await populate_form();
  return Browser.submitListen(Browser.getElement("metrics_form", "Metrics.addSubmitListener"), submit_handler);
}

export {
  populate_form ,
  submit_handler ,
  structure ,
}
/* No side effect */
