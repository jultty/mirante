# the strings for this test are based on the following blog post:
# https://minasprogramam.com/leitura-da-vez-more-than-a-glitch-da-meredith-broussard/

# can create an account
POST http://localhost:3031/rpc/signup
{
    "email": "maite@mirante.jutty.dev",
    "password": "b14c120c5"
}

HTTP 200
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.email" == "maite@mirante.jutty.dev"
jsonpath "$.token" != null
jsonpath "$.token" matches /.+\..+\..+/

# can obtain a token
POST http://localhost:3031/rpc/login
{
    "email": "maite@mirante.jutty.dev",
    "password": "b14c120c5"
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
  "name": "Gênero, Raça e Tecnologia"
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

# can create options with token
POST http://localhost:3031/option
Authorization: Bearer {{token}}
{
  "content": "subjetivas e abstratas",
  "correct": false,
  "place": 1,
  "exercise": 1
}

HTTP 201

POST http://localhost:3031/option
Authorization: Bearer {{token}}
{
  "content": "neutras e objetivas",
  "correct": true,
  "place": 2,
  "exercise": 1
}

HTTP 201

POST http://localhost:3031/option
Authorization: Bearer {{token}}
{
  "content": "previsíveis e abertas",
  "correct": false,
  "place": 3,
  "exercise": 1
}

HTTP 201

POST http://localhost:3031/option
Authorization: Bearer {{token}}
{
  "content": "concretas e relativas",
  "correct": false,
  "place": 4,
  "exercise": 1
}

HTTP 201
