# can create an account
POST http://localhost:3031/rpc/signup
{
    "email": "augusta@mirante.jutty.dev",
    "password": "xyz606060"
}

HTTP 200
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.user.email" == "augusta@mirante.jutty.dev"
jsonpath "$.token" != null
jsonpath "$.token" matches /.+\..+\..+/

# can obtain a token
POST http://localhost:3031/rpc/login
{
    "email": "augusta@mirante.jutty.dev",
    "password": "xyz606060"
}

HTTP 200
[Captures]
token: jsonpath "$.token"
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.token" != null
jsonpath "$.token" matches /.+\..+\..+/

# can create a course with token
POST http://localhost:3031/course
Authorization: Bearer {{token}}
{
  "name": "Course Test 00A"
}

HTTP 201
