# client can create an account
POST http://localhost:3031/rpc/signup
{
    "email": "tania@mirante.jutty.dev",
    "password": "xyz606060"
}

HTTP 200
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.user.email" == "tania@mirante.jutty.dev"
jsonpath "$.token" != null
jsonpath "$.token" matches /.+\..+\..+/

# client can't create an account without providing an email
POST http://localhost:3031/rpc/signup
{
    "password": "xyz606060"
}

HTTP 404

# client can't create an account without providing a valid email
POST http://localhost:3031/rpc/signup
{
    "email": "tania2@mirante",
    "password": "xyz606060"
}

HTTP 400

# client can't create an account without providing a password
POST http://localhost:3031/rpc/signup
{
    "email": "tania3@mirante.jutty.dev"
}

HTTP 404

# client can't create an account with an empty password
POST http://localhost:3031/rpc/signup
{
    "email": "tania4@mirante.jutty.dev",
    "password": ""
}

HTTP 403

# client can't create an account with a password with less than 8 characters
POST http://localhost:3031/rpc/signup
{
    "email": "tania5@mirante.jutty.dev",
    "password": "1234567"
}

HTTP 403

# client can't create an account with an already registered email
POST http://localhost:3031/rpc/signup
{
    "email": "tania@mirante.jutty.dev",
    "password": "xyz606060"
}

HTTP 409
