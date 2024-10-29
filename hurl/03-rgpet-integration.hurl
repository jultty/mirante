# integrator can get a login token
POST http://localhost:3031/rpc/login
{
    "email": "rgpet@mirante.jutty.dev",
    "password": "nZmZm8BgA"
}

HTTP 200
[Captures]
token: jsonpath "$.token"
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.token" != null
jsonpath "$.token" matches /.+\..+\..+/


# integrator can read account details
POST http://localhost:3031/rpc/rgpet
Authorization: Bearer {{token}}
{
  "user_email": "tania@mirante.jutty.dev"
}

HTTP 200

# an anonymous user can't read account details
POST http://localhost:3031/rpc/rgpet
{
  "user_email": "tania@mirante.jutty.dev"
}

HTTP 401

# a user other than integrator can't read account details
POST http://localhost:3031/rpc/signup
{
    "email": "not_integrator@mirante.jutty.dev",
    "password": "xyz000000"
}

HTTP 200
[Captures]
not_integrator_token: jsonpath "$.token"

POST http://localhost:3031/rpc/rgpet
Authorization: Bearer {{not_integrator_token}}
{
  "user_email": "tania@mirante.jutty.dev"
}

HTTP 403
