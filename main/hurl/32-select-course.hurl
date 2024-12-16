# [a01] can create an account
POST http://localhost:3031/rpc/signup
{
    "email": "select_a01@mirante.jutty.dev",
    "password": "xyz808080"
}

HTTP 200
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.email" == "select_a01@mirante.jutty.dev"
jsonpath "$.token" != null
jsonpath "$.token" matches /.+\..+\..+/

# [b01] can create an account
POST http://localhost:3031/rpc/signup
{
    "email": "select_b01@mirante.jutty.dev",
    "password": "xyz808080"
}

HTTP 200
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.email" == "select_b01@mirante.jutty.dev"
jsonpath "$.token" != null
jsonpath "$.token" matches /.+\..+\..+/

# [a01] can obtain a token
POST http://localhost:3031/rpc/login
{
    "email": "select_a01@mirante.jutty.dev",
    "password": "xyz808080"
}

HTTP 200
[Captures]
a01_token: jsonpath "$.token"
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.token" != null
jsonpath "$.token" matches /.+\..+\..+/

# [b01] can obtain a token
POST http://localhost:3031/rpc/login
{
    "email": "select_b01@mirante.jutty.dev",
    "password": "xyz808080"
}

HTTP 200
[Captures]
b01_token: jsonpath "$.token"
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.token" != null
jsonpath "$.token" matches /.+\..+\..+/

# [a01] can create a course with token
POST http://localhost:3031/course
Authorization: Bearer {{a01_token}}
{
  "name": "Course Test 001A"
}

HTTP 201

# [b01] can create a course with token
POST http://localhost:3031/course
Authorization: Bearer {{b01_token}}
{
  "name": "Course Test 001B"
}

HTTP 201

# [a01] can read course list with token
GET http://localhost:3031/course
Authorization: Bearer {{a01_token}}

HTTP 200
[Captures]
a01_course_id: jsonpath "$.[0].id"
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.[0].name" == "Course Test 001A"

# [b01] can read course list with token
GET http://localhost:3031/course
Authorization: Bearer {{b01_token}}

HTTP 200
[Captures]
b01_course_id: jsonpath "$.[0].id"
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.[0].name" == "Course Test 001B"

# [a01] read course list contains a single item
GET http://localhost:3031/course
Authorization: Bearer {{a01_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.[*]" count == 1

# [b01] read course list contains a single item
GET http://localhost:3031/course
Authorization: Bearer {{b01_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.[*]" count == 1

# [a01] read course list does not contain b01's course
GET http://localhost:3031/course
Authorization: Bearer {{a01_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.[*].name" includes "Course Test 001A"
jsonpath "$.[*].name" not includes "Course Test 001B"

# [b01] read course list does not contain a01's course
GET http://localhost:3031/course
Authorization: Bearer {{b01_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.[*].name" includes "Course Test 001B"
jsonpath "$.[*].name" not includes "Course Test 001A"

# [a01] can see one's own course by id
GET http://localhost:3031/course?id=eq.{{a01_course_id}}
Authorization: Bearer {{a01_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.[*]" count == 1
jsonpath "$.[0].name" == "Course Test 001A"
jsonpath "$.[*].name" not includes "Course Test 001B"

# [a01] can't see another's course by id
GET http://localhost:3031/course?id=eq.{{b01_course_id}}
Authorization: Bearer {{a01_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.[*]" count == 0
jsonpath "$.[*].name" not includes "Course Test 001B"
jsonpath "$.[*].name" not includes "Course Test 001A"

# [b01] can see only one's own course by id
GET http://localhost:3031/course?id=eq.{{b01_course_id}}
Authorization: Bearer {{b01_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.[*]" count == 1
jsonpath "$.[0].name" == "Course Test 001B"
jsonpath "$.[*].name" not includes "Course Test 001A"

# [b01] can't see another's course by id
GET http://localhost:3031/course?id=eq.{{a01_course_id}}
Authorization: Bearer {{b01_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.[*]" count == 0
jsonpath "$.[*].name" not includes "Course Test 001A"
jsonpath "$.[*].name" not includes "Course Test 001B"
