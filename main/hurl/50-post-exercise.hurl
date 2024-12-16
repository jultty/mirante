# the strings for this test are based on the following blog post:
# https://minasprogramam.com/leitura-da-vez-more-than-a-glitch-da-meredith-broussard/

# can create an account
POST http://localhost:3031/rpc/signup
{
    "email": "barbara@mirante.jutty.dev",
    "password": "47EA6E65726F2C205261E7612065205465636E6F6C6F676961"
}

HTTP 200
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.email" == "barbara@mirante.jutty.dev"
jsonpath "$.token" != null
jsonpath "$.token" matches /.+\..+\..+/

# can obtain a token
POST http://localhost:3031/rpc/login
{
    "email": "barbara@mirante.jutty.dev",
    "password": "47EA6E65726F2C205261E7612065205465636E6F6C6F676961"
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
  "name": "Leitura: More than a Glitch"
}

HTTP 201

# can create an exercise set with token
POST http://localhost:3031/exercise_set
Authorization: Bearer {{token}}
{
  "name": "Gênero, Raça e Tecnologia",
  "course": 1
}

HTTP 201

# can create an exercise with token
POST http://localhost:3031/exercise
Authorization: Bearer {{token}}
{
  "instruction": "Para Broussard, muitos 'tecno chauvinistas' vêem os dados e a tecnologia como coisas:",
  "set": 1
}

HTTP 201
