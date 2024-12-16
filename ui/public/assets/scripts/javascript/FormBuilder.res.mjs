// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Auth from "./Auth.res.mjs";
import * as Meta from "./Meta.res.mjs";
import * as Browser from "./Browser.res.mjs";
import * as Core__Option from "@rescript/core/src/Core__Option.res.mjs";

function find_display_name(element, entity) {
  var error_reference = entity !== undefined ? "entity" + entity.display_name : "concrete entity with id " + element.id;
  var name = element.name;
  var name$1;
  if (name !== undefined) {
    name$1 = name;
  } else {
    var instruction = element.instruction;
    if (instruction !== undefined) {
      name$1 = "(" + element.id + ") " + instruction;
    } else {
      var content = element.content;
      if (content !== undefined) {
        name$1 = "(" + element.id + ") " + content;
      } else {
        throw {
              RE_EXN_ID: Meta.IncompleteSchema,
              _1: "[FormBuilder.update_table]Could not find a suitable name for " + error_reference,
              Error: new Error()
            };
      }
    }
  }
  if (name$1.length > 30) {
    return name$1.slice(0, 30) + "…";
  } else {
    return name$1;
  }
}

async function make_field(form, field) {
  var label = Browser.makeElement("label");
  label.for = field.id;
  label.innerText = field.label;
  form.appendChild(label);
  form.appendChild(Browser.makeElement("br"));
  if (field.type === "select") {
    var relation_details = Core__Option.getExn(field.relation_details, "[FormBuilder.make_field] Details not defined for select field " + field.id);
    var reference = Core__Option.getExn(relation_details.reference, "[FormBuilder.make_field] Reference not defined for select field " + field.id);
    var get_options = Auth.make_get_options();
    var related = await globalThis.fetch(Meta.schema.system.constants.root_url + "/" + reference, get_options);
    var array = await related.json();
    var select = Browser.makeElement("select");
    select.id = field.id;
    select.name = field.id;
    array.forEach(function (option) {
          var name = find_display_name(option, undefined);
          var element = Browser.makeElement("option");
          element.value = option.id;
          element.innerText = name;
          select.appendChild(element);
        });
    form.appendChild(select);
    form.appendChild(Browser.makeElement("br"));
    return ;
  }
  var input = Browser.makeElement("input");
  input.type = field.type;
  input.id = field.id;
  input.name = field.id;
  form.appendChild(input);
  form.appendChild(Browser.makeElement("br"));
}

function make_submit_button(form, text) {
  var button = Browser.makeElement("input");
  button.type = "submit";
  button.value = text;
  form.appendChild(button);
}

async function make_form(fields, id) {
  var form = Browser.makeElement("form");
  for(var i = 0 ,i_finish = fields.length; i < i_finish; ++i){
    var field = Core__Option.getExn(fields[i], "[FormBuilder.make_form]" + ("Field on index " + String(i) + " should not be None"));
    await make_field(form, field);
  }
  make_submit_button(form, "Enviar");
  form.id = id;
  return form;
}

export {
  find_display_name ,
  make_field ,
  make_submit_button ,
  make_form ,
}
/* No side effect */
