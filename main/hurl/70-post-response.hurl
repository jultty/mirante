# can create an account
POST http://localhost:3031/rpc/signup
[Options]
variable: email=edwin@mirante.jutty.dev
variable: password=prelude-of-post-dependents
{
    "email": "{{email}}",
    "password": "{{password}}"
}

HTTP 200
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.email" == "{{email}}"
jsonpath "$.token" != null
jsonpath "$.token" matches /.+\..+\..+/

# can obtain a token
POST http://localhost:3031/rpc/login
{
    "email": "{{email}}",
    "password": "{{password}}"
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
  "name": "Type-Driven Development with Idris"
}

HTTP 201

# can create an exercise set with token
POST http://localhost:3031/exercise_set
Authorization: Bearer {{token}}
{
  "name": "Side-effects",
  "course": 1
}

HTTP 201

# EXERCISE 1

POST http://localhost:3031/exercise
Authorization: Bearer {{token}}
{
  "instruction": "Realistically, programs must _______  side effects in order to be useful",
  "set": 1
}

HTTP 201

# can create options with token
POST http://localhost:3031/option
Authorization: Bearer {{token}}
{
  "content": "avoid",
  "correct": false,
  "exercise": 1
}

HTTP 201

POST http://localhost:3031/option
Authorization: Bearer {{token}}
{
  "content": "have",
  "correct": true,
  "exercise": 1
}

HTTP 201

POST http://localhost:3031/option
Authorization: Bearer {{token}}
{
  "content": "eliminate",
  "correct": false,
  "exercise": 1
}

HTTP 201

POST http://localhost:3031/option
Authorization: Bearer {{token}}
{
  "content": "conceal",
  "correct": false,
  "exercise": 1
}

HTTP 201

# EXERCISE 2

POST http://localhost:3031/exercise
Authorization: Bearer {{token}}
{
  "instruction": "The key idea that allows us to write interactive programs in Idris [...] is that we distinguish between _______ and ________",
  "set": 1
}

HTTP 201

POST http://localhost:3031/option
Authorization: Bearer {{token}}
{
  "content": "evaluation and execution",
  "correct": true,
  "exercise": 2
}

HTTP 201

POST http://localhost:3031/option
Authorization: Bearer {{token}}
{
  "content": "static and dynamic",
  "correct": false,
  "exercise": 2
}

HTTP 201

POST http://localhost:3031/option
Authorization: Bearer {{token}}
{
  "content": "abstract and concrete",
  "correct": false,
  "exercise": 2
}

HTTP 201

POST http://localhost:3031/option
Authorization: Bearer {{token}}
{
  "content": "dependent and atomic",
  "correct": false,
  "exercise": 2
}

HTTP 201

# can submit responses
POST http://localhost:3031/response
Authorization: Bearer {{token}}
{
  "option": 2
}

HTTP 201

POST http://localhost:3031/response
Authorization: Bearer {{token}}
{
  "option": 6
}

POST http://localhost:3031/response
Authorization: Bearer {{token}}
{
  "option": 8
}

POST http://localhost:3031/response
Authorization: Bearer {{token}}
{
  "option": 2
}

POST http://localhost:3031/response
Authorization: Bearer {{token}}
{
  "option": 4
}
