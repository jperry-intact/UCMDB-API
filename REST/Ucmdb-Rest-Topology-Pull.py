import string
import requests
import ast
import json

ucmdb_user = "****UCMDB_USER****"
ucmdb_password = "****UCMDB_PASSWORD****"
ucmdb_root_url_and_port = "****UCMDB_PROTOCOL****://****UCMDB_HOST****:****UCMDB_PORT****"
ucmdb_tql_query = "****UCMDB_TQL_QUERY****"

ucmdb_auth_uri = ucmdb_root_url_and_port + "/rest-api/authenticate"
ucmdb_topology_uri = ucmdb_root_url_and_port + "/rest-api/topologyQuery"

task = {"username":ucmdb_user,"password":ucmdb_password,"clientContext":1}
authresp = requests.post(ucmdb_auth_uri, json=task, verify=False)

authjsonReturn = authresp.json()
authParsedValue = authjsonReturn['token']
auth_value = "'Authorization': 'Bearer " + authParsedValue +"'"
auth_cookie = "{" + auth_value + "}"
dict_auth = ast.literal_eval(auth_cookie)

with open("TopologyQuery.json") as json_file:
    json_topologyqueryraw = json.load(json_file)

json_topologyquery = json.dumps(json_topologyqueryraw)

topologyresp = requests.post(ucmdb_topology_uri, headers=dict_auth, json=json_topologyquery, verify=False)
topologyjsonReturn = topologyresp.json()
topologyjsonReturnformatted = json.dumps(topologyjsonReturn, indent=1, sort_keys=True)

print(topologyjsonReturnformatted)