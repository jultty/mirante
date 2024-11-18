// Constants

type endpoints = {
  signup: string,
  login: string,
  version: string,
  current_version: string,
  course: string,
}

let endpoints = {
  signup: "http://localhost:3031/rpc/signup",
  login: "http://localhost:3031/rpc/login",
  version: "http://localhost:3031/version",
  current_version: "http://localhost:3031/version?current=is.true",
  course: "",
}

type constants = {
  storage_key: string,
}

let constants = {
  storage_key: "mirante_credentials",
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
