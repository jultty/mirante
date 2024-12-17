// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Caml_exceptions from "rescript/lib/es6/caml_exceptions.js";

var client_version = {
  major: 0,
  minor: 2,
  patch: 0
};

var server_version = {
  major: 0,
  minor: 6,
  patch: 0
};

var root_url = "http://localhost:3031";

var schema_system = {
  client_version: client_version,
  server_version: server_version,
  supported_server_versions: {
    minimum: server_version,
    current: server_version,
    maximum: server_version
  },
  supported_client_versions: {
    minimum: client_version,
    current: client_version,
    maximum: client_version
  },
  constants: {
    root_url: root_url,
    storage_key: "mirante_credentials"
  },
  endpoints: {
    signup: root_url + "/rpc/signup",
    login: root_url + "/rpc/login",
    version: root_url + "/version",
    version_current: root_url + "/version?current=is.true"
  }
};

var schema_entity = {
  course: {
    slug: "course",
    display_name: "curso",
    plural_display_name: "cursos",
    view: {
      table: {
        headers: ["Nome"]
      },
      form: {
        fields: [{
            id: "name",
            type: "text",
            label: "Nome"
          }]
      }
    }
  },
  exercise_set: {
    slug: "exercise_set",
    display_name: "conjunto de exercícios",
    plural_display_name: "conjuntos de exercícios",
    view: {
      table: {
        headers: [
          "Nome",
          "Curso"
        ],
        columns: [{
            display_name: "Curso",
            kind: "ForeignString",
            options: {
              reference: "course",
              display_field: "name",
              concrete_field: "course",
              array: []
            }
          }]
      },
      form: {
        fields: [
          {
            id: "name",
            type: "text",
            label: "Nome"
          },
          {
            id: "course",
            type: "select",
            label: "Curso",
            relation_details: {
              reference: "course",
              display_field: "name",
              concrete_field: "course",
              array: []
            }
          }
        ]
      }
    }
  },
  exercise: {
    slug: "exercise",
    display_name: "exercício",
    plural_display_name: "exercícios",
    view: {
      table: {
        headers: [
          "Instrução",
          "Conjunto"
        ],
        columns: [{
            display_name: "Conjunto",
            kind: "ForeignString",
            options: {
              reference: "exercise_set",
              display_field: "name",
              concrete_field: "set",
              array: []
            }
          }]
      },
      form: {
        fields: [
          {
            id: "instruction",
            type: "text",
            label: "Instrução"
          },
          {
            id: "set",
            type: "select",
            label: "Conjunto",
            relation_details: {
              reference: "exercise_set",
              display_field: "name",
              concrete_field: "set",
              array: []
            }
          }
        ]
      }
    }
  },
  option: {
    slug: "option",
    display_name: "alternativa",
    plural_display_name: "alternativas",
    view: {
      table: {
        headers: [
          "Conteúdo",
          "Exercício",
          "Correta",
          "Posição"
        ],
        columns: [
          {
            display_name: "Exercício",
            kind: "ForeignString",
            options: {
              reference: "exercise",
              display_field: "instruction",
              concrete_field: "exercise",
              array: []
            }
          },
          {
            display_name: "Correta",
            kind: "Boolean",
            value: "correct"
          },
          {
            display_name: "Posição",
            kind: "Integer"
          }
        ]
      },
      form: {
        fields: [
          {
            id: "content",
            type: "text",
            label: "Conteúdo"
          },
          {
            id: "exercise",
            type: "select",
            label: "Exercício",
            relation_details: {
              reference: "exercise",
              display_field: "instruction",
              concrete_field: "instruction",
              array: []
            }
          },
          {
            id: "correct",
            type: "checkbox",
            label: "Correta"
          },
          {
            id: "place",
            type: "integer",
            label: "Posição"
          }
        ]
      }
    }
  },
  response: {
    slug: "response",
    display_name: "resposta",
    plural_display_name: "respostas",
    view: {
      table: {
        headers: []
      },
      form: {
        fields: []
      }
    }
  },
  metric: {
    slug: "metric",
    display_name: "métrica",
    plural_display_name: "métricas",
    view: {
      table: {
        headers: []
      },
      form: {
        fields: []
      }
    }
  }
};

var schema = {
  system: schema_system,
  entity: schema_entity
};

var IncompleteSchema = /* @__PURE__ */Caml_exceptions.create("Meta.IncompleteSchema");

function make_endpoint(entity) {
  var slug = entity.endpoint_slug;
  if (slug !== undefined) {
    return schema_system.constants.root_url + "/" + slug;
  } else {
    return schema_system.constants.root_url + "/" + entity.slug;
  }
}

function make_slug(kind, entity) {
  switch (kind) {
    case "CreationForm" :
        return entity.slug + "_creation_form";
    case "Table" :
        return entity.slug + "_table";
    case "TableHeader" :
        return entity.slug + "_table_header";
    case "Checkbox" :
        return entity.slug + "_checkbox";
    
  }
}

export {
  client_version ,
  server_version ,
  root_url ,
  schema ,
  IncompleteSchema ,
  make_endpoint ,
  make_slug ,
}
/* No side effect */
