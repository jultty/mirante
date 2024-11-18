// Constants

type constants = {
  root_url: string,
  storage_key: string,
}

let constants = {
  root_url: "http://localhost:3031",
  storage_key: "mirante_credentials",
}

type endpoints = {
  signup: string,
  login: string,
  version: string,
  current_version: string,
  course: string,
}

let endpoints = {
  signup: `${constants.root_url}/rpc/signup`,
  login: `${constants.root_url}/rpc/login`,
  version: `${constants.root_url}/version`,
  current_version: `${constants.root_url}/version?current=is.true`,
  course: `${constants.root_url}/course`,
}

// Versions

type semantic_version = {
  major: int,
  minor: int,
  patch: int,
}

let client_version = { major: 0, minor: 1, patch: 0 }

type supported_server_versions = {
  minimum: semantic_version,
  current: semantic_version,
  maximum: semantic_version,
}

let supported_server_versions = {
  minimum: { major: 0, minor: 4, patch: 0 },
  current: { major: 0, minor: 4, patch: 0 },
  maximum: { major: 0, minor: 4, patch: 0 },
}
