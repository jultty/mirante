# user can create an account
POST http://localhost:6060/account
{
    "name": "Jane Foobar",
    "username": "janex",
    "email": "jane@mirante.dev",
    "password": "xyz6060"
}

HTTP 200
[Asserts]
jsonpath "$.name" == "Jane Foobar"
jsonpath "$.username" == "janex"
jsonpath "$.email" == "jane@mirante.dev"
