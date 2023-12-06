# a descriptive comment here
GET http://localhost:6060/hello/Jane

HTTP 200
[Asserts]
jsonpath "$.hello" == "Jane"
