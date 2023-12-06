# user can get an account's details provided they have the password
GET http://localhost:6060/account/janex
{
  "password": "xyz6060"
}

HTTP 200
[Asserts]
jsonpath "$.name" == "Jane Foobar"
jsonpath "$.email" == "jane@mirante.dev"

# user can NOT get an account's details if they DON'T have the password
GET http://localhost:6060/account/janex
{
  "password": "xyz"
}

HTTP 403
