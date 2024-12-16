// [ Entity Meta ]

// Entity display

type table = {
  title?: string,
  headers: array<string>,
}

type options = {
  reference?: string,
  display_field: string,
  array?: array<string>,
}

type field = {
  id: string,
  @as("type") kind: string,
  text?: string,
  label?: string,
  options?: options
}

type form = {
  title?: string,
  fields: array<field>,
}

type view = {
  table: table,
  form: form,
}

// Entity schema

type entity = {
  slug: string,
  display_name: string,
  plural_display_name: string,
  endpoint_slug?: string,
  view: view,
}

// TODO move to Browser
type generic_response_store<'a> = {
  mutable response?: BrowserTypes.response,
  mutable json?: BrowserTypes.response_body,
  mutable array?: array<'a>
}

// Entity concrete types

type concrete_entity = {
  @as("id") database_id: string,
  name?: string,
  instruction?: string,
  exercise_set?: int,
}

type course = {
  ...concrete_entity,
}

type exercise_set = {
  ...concrete_entity,
}

type entity_schema = {
  course: entity,
  exercise_set: entity,
  exercise: entity,
  option?: entity,
  response?: entity,
  account?: entity,
  version?: entity,
  metric?: entity,
}

// [ System Meta ]

// System versions

type semantic_version = {
  major: int,
  minor: int,
  patch: int,
}

type supported_server_versions = {
  minimum: semantic_version,
  current: semantic_version,
  maximum: semantic_version,
}

// System constants

type constants = {
  root_url: string,
  storage_key: string,
}

// System endpoints

type system_endpoints = {
  signup: string,
  login: string,
  version: string,
  version_current: string,
}

type system_schema = {
  client_version: semantic_version,
  server_version: semantic_version,
  supported_server_versions: supported_server_versions,
  supported_client_versions: supported_server_versions,
  constants: constants,
  endpoints: system_endpoints,
}

// [ Main Meta ]

type schema = {
  system: system_schema,
  entity: entity_schema,
}

let client_version = { major: 0, minor: 1, patch: 0 }
let server_version = { major: 0, minor: 5, patch: 0 }
let root_url = "http://localhost:3031"

let schema: schema = {
  system: {
    client_version: client_version,
    server_version: server_version,
    supported_server_versions: { minimum: server_version, current: server_version, maximum: server_version },
    supported_client_versions: { minimum: client_version, current: client_version, maximum: client_version },
    constants:  {
      root_url: root_url,
      storage_key: "mirante_credentials",
    },
    endpoints: {
      signup: `${root_url}/rpc/signup`,
      login: `${root_url}/rpc/login`,
      version: `${root_url}/version`,
      version_current: `${root_url}/version?current=is.true`,
    },
  },
  entity: {
    course: {
      slug: "course",
      display_name: "curso",
      plural_display_name: "cursos",
      view: {
        table: {
          headers: [ "Nome", ]
        },
        form: {
          fields: [ { label: "Nome", id: "name", kind: "text" } ],
        }
      },
    },
    exercise_set: {
      display_name: "conjunto de exercícios",
      plural_display_name: "conjuntos de exercícios",
      slug: "exercise_set",
      view: {
        table: {
          headers: [ "Nome", ]
        },
        form: {
          fields: [
          { label: "Nome", id: "name", kind: "text" } ,
          {
            label: "Curso",
            id: "course",
            kind: "select",
            options: {
              reference: "course",
              display_field: "name",
              array: [],
            },
          },
          ],
        }
      }
    },
    exercise: {
      display_name: "exercício",
      plural_display_name: "exercícios",
      slug: "exercise",
      view: {
        table: {
          headers: [ "Instrução", "Conjunto", ]
        },
        form: {
          fields: [
            { label: "Instrução", id: "instruction", kind: "text" },
            {
              label: "Conjunto",
              id: "set",
              kind: "select",
              options: {
                reference: "exercise_set",
                display_field: "name",
                array: [],
              },
            },
          ],
        },
      }
    },
  }
}

// Helper functions

let make_endpoint = (entity: entity) => {
  switch entity.endpoint_slug {
  | Some(slug) => `${schema.system.constants.root_url}/${slug}`
  | None => `${schema.system.constants.root_url}/${entity.slug}`
  }
}

type slug_kind = CreationForm | Table | TableHeader | Checkbox

let make_slug = (kind: slug_kind, entity: entity): string => {
  switch kind {
  | CreationForm => `${entity.slug}_creation_form`
  | Table => `${entity.slug}_table`
  | TableHeader => `${entity.slug}_table_header`
  | Checkbox => `${entity.slug}_checkbox`
  }
}
