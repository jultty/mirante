# a descriptive comment here
GET http://localhost:6060/user/Jane

HTTP 200
[Asserts]
jsonpath "$.name" == "Jane"
