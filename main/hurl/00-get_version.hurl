# client can query the version without authentication
GET http://localhost:3031/version?current=is.true

HTTP 200
[Captures]
minor: regex /"tag":\s*"v\d+\.(\d+)\.\d+"/
[Asserts]
header "Content-Type" == "application/json; charset=utf-8"
jsonpath "$.[0].tag" isString
jsonpath "$.[0].tag" matches /v\d+\.\d+\.\d+/
variable "minor" toInt >= 4

# client can query the version without authentication
# and get a single object outside an array if desired
GET http://localhost:3031/version?current=is.true
Accept: application/vnd.pgrst.object+json

HTTP 200
[Captures]
minor: regex /"tag":\s*"v\d+\.(\d+)\.\d+"/
[Asserts]
header "Content-Type" == "application/vnd.pgrst.object+json; charset=utf-8"
jsonpath "$.tag" isString
jsonpath "$.tag" matches /v\d+\.\d+\.\d+/
variable "minor" toInt >= 4
