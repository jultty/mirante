# a descriptive comment here
POST http://localhost:6060/hello
{
    "name": "Jane"
}

HTTP 200
[Asserts]
jsonpath "$.name" == "Jane"
