# can create an account
POST http://localhost:3031/rpc/signup
{
    "email": "silvana@mirante.jutty.dev",
    "password": "0x511b4814"
}

HTTP 200
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.email" == "silvana@mirante.jutty.dev"
jsonpath "$.token" != null
jsonpath "$.token" matches /.+\..+\..+/

# can obtain a token
POST http://localhost:3031/rpc/login
{
    "email": "silvana@mirante.jutty.dev",
    "password": "0x511b4814"
}

HTTP 200
[Captures]
token: jsonpath "$.token"
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.token" != null
jsonpath "$.token" matches /.+\..+\..+/

# can create an exercise set with token
POST http://localhost:3031/exercise_set
Authorization: Bearer {{token}}
{
  "name": "Backends Dadocentrados",
  "course": 1
}

HTTP 201
