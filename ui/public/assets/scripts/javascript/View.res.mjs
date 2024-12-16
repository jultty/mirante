// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Auth from "./Auth.res.mjs";
import * as Meta from "./Meta.res.mjs";
import * as Util from "./Util.res.mjs";
import * as Browser from "./Browser.res.mjs";
import * as FormBuilder from "./FormBuilder.res.mjs";
import * as Core__Option from "@rescript/core/src/Core__Option.res.mjs";
import * as Caml_js_exceptions from "rescript/lib/es6/caml_js_exceptions.js";

function make_header_row(entity) {
  var headers = entity.view.table.headers;
  var header_row = Browser.makeElement("tr");
  var checkbox_header = Browser.makeElement("th");
  checkbox_header.id = "checkbox_header";
  var select_all_checkbox = Browser.makeElement("input");
  select_all_checkbox.type = "checkbox";
  select_all_checkbox.id = "select_all_checkbox";
  checkbox_header.appendChild(select_all_checkbox);
  header_row.appendChild(checkbox_header);
  headers.forEach(function (header) {
        var element = Browser.makeElement("th");
        element.id = Meta.make_slug("TableHeader", entity);
        element.innerText = header;
        header_row.appendChild(element);
      });
  var edit_header = Browser.makeElement("th");
  edit_header.id = "edit_header";
  edit_header.innerText = "Editar";
  header_row.appendChild(edit_header);
  return header_row;
}

function make_table(entity) {
  var div = Browser.makeElement("div");
  var header = Browser.makeElement("h2");
  var text = entity.view.table.title;
  header.innerText = Util.to_sentence_title_case(text !== undefined ? text : entity.plural_display_name);
  div.appendChild(header);
  var table = Browser.makeElement("table");
  table.id = Meta.make_slug("Table", entity);
  var header_row = make_header_row(entity);
  table.appendChild(header_row);
  div.appendChild(table);
  div.appendChild(Browser.makeElement("br"));
  var delete_button = Browser.makeElement("button");
  delete_button.id = "delete_button";
  delete_button.innerText = "Excluir selecionados";
  div.appendChild(delete_button);
  return div;
}

function reset_table(entity) {
  var table = Browser.getElement(Meta.make_slug("Table", entity), entity.slug + " reset_table");
  Browser.clearChildren(table);
  var header_row = make_header_row(entity);
  table.appendChild(header_row);
}

async function update_table(entity) {
  var table = Browser.getElement(Meta.make_slug("Table", entity), entity.slug + " update_table");
  var token = Auth.getCredentials().token;
  var response_store = {};
  var get_options = {
    method: "GET",
    headers: {
      "Content-Type": "application/json",
      Authorization: "Bearer " + token
    }
  };
  reset_table(entity);
  var response = await globalThis.fetch(Meta.make_endpoint(entity), get_options);
  response_store.response = await response.clone();
  response_store.array = await response.json();
  var found_array = response_store.array;
  var array = found_array !== undefined ? found_array : [];
  array.forEach(function (element) {
        var row = Browser.makeElement("tr");
        var checkbox_cell = Browser.makeElement("td");
        var checkbox = Browser.makeElement("input");
        checkbox.type = "checkbox";
        checkbox.id = entity.slug + "_" + element.id + "_checkbox";
        checkbox.class = "select_row_checkbox";
        checkbox_cell.appendChild(checkbox);
        row.appendChild(checkbox_cell);
        var name_cell = Browser.makeElement("td");
        name_cell.innerText = Core__Option.getOr(element.name, "Item sem nome");
        row.appendChild(name_cell);
        var edit_cell = Browser.makeElement("td");
        var edit_button = Browser.makeElement("button");
        edit_button.innerText = "Editar";
        edit_button.id = entity.slug + "_" + element.id + "_edit_button";
        edit_button.class = "edit_row_button";
        edit_cell.appendChild(edit_button);
        row.appendChild(edit_cell);
        table.appendChild(row);
      });
}

async function make_creation_form(entity) {
  var div = Browser.makeElement("div");
  var fields = entity.view.form.fields;
  var header = Browser.makeElement("h2");
  header.innerText = "Novo " + entity.display_name;
  div.appendChild(header);
  var form = await FormBuilder.make_form(fields, entity.slug + "_creation_form");
  div.appendChild(form);
  return div;
}

function make_creation_handler(entity) {
  return async function ($$event) {
    $$event.preventDefault();
    var dialog = Browser.getElement("user_dialog", entity.slug + ".creation_handler.dialog");
    var form = Browser.getElement(Meta.make_slug("CreationForm", entity), entity.slug + ".creation_handler.form");
    dialog.innerText = "";
    var form_data = Object.fromEntries(new FormData(form));
    var token = Auth.getCredentials().token;
    var post_options = {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: "Bearer " + token
      },
      body: JSON.stringify(form_data)
    };
    var response_store = {};
    try {
      var response = await globalThis.fetch(Meta.make_endpoint(entity), post_options);
      response_store.response = await response.clone();
    }
    catch (raw_error){
      var error = Caml_js_exceptions.internalToOCamlException(raw_error);
      console.log(error);
      dialog.innerText = "[${schema.entity_name}.creation_handler] Erro na requisição";
    }
    try {
      var response$1 = response_store.response;
      var response$2 = response$1 !== undefined ? response$1 : ({
            __client_error: "[" + entity.slug + " creation_handler] No response in response_store"
          });
      var status = Core__Option.getExn(response$2.status, "[" + entity.slug + " creation_handler.status] Destructuring error");
      var exit = 0;
      if (status > 403 || status < 400) {
        if (status === 201 || status === 200) {
          dialog.innerText = "Criação de " + entity.display_name + " feita com sucesso";
          await update_table(entity);
          return ;
        }
        exit = 1;
      } else {
        if (status < 401) {
          dialog.innerText = "Requisição inválida. Os dados informados estão corretos?";
          return ;
        }
        switch (status) {
          case 401 :
              dialog.innerText = "Sua conta não possui acesso a este recurso";
              return ;
          case 402 :
              exit = 1;
              break;
          case 403 :
              dialog.innerText = "Requisição inválida. Os dados informados estão corretos?";
              return ;
          
        }
      }
      if (exit === 1) {
        console.log("[" + entity.slug + " creation_handler.status] Unexpected return status " + status.toString());
        return ;
      }
      
    }
    catch (raw_error$1){
      var error$1 = Caml_js_exceptions.internalToOCamlException(raw_error$1);
      console.log(error$1);
      dialog.innerText = "[${schema.entity_name}.creation_handler] Erro ao processar resposta";
      return ;
    }
  };
}

function make_nav_handler(entity) {
  return async function ($$event) {
    $$event.preventDefault();
    var credentials = Auth.getCredentialsOption();
    var dialog = Browser.getElement("user_dialog", "View.make_nav_handler dialog");
    if (!Core__Option.isSome(credentials)) {
      dialog.innerText = "Crie uma conta ou faça login primeiro";
      return ;
    }
    var table = make_table(entity);
    var form = await make_creation_form(entity);
    Browser.submitListen(form, make_creation_handler(entity));
    var main = Browser.getElementByTag("main", "View.make_nav_handler main");
    Browser.clearChildren(main);
    main.appendChild(table);
    main.appendChild(form);
    await update_table(entity);
  };
}

export {
  make_header_row ,
  make_table ,
  reset_table ,
  update_table ,
  make_creation_form ,
  make_creation_handler ,
  make_nav_handler ,
}
/* No side effect */
