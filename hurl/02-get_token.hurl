# tests in this file only pass if ran after 01-post_account.hurl

# client can get a token using their credentials
POST http://localhost:3031/rpc/login
{
    "email": "tania@mirante.jutty.dev",
    "password": "xyz606060"
}

HTTP 200
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.token" != null
jsonpath "$.token" matches /.+\..+\..+/

# wrong password returns a 403 error
POST http://localhost:3031/rpc/login
{
    "email": "tania@mirante.jutty.dev",
    "password": "xyz7771"
}

HTTP 403

# wrong email returns a 403 error
POST http://localhost:3031/rpc/login
{
    "email": "jc100001",
    "password": "xyz6060"
}

HTTP 403
