import string
import requests
import ast
import json

ucmdb_user = "****UCMDB_USER****"
ucmdb_password = "****UCMDB_PASSWORD****"
ucmdb_root_url_and_port = "****UCMDB_PROTOCOL****://****UCMDB_HOST****:****UCMDB_PORT****"
ucmdb_tql_query = "****UCMDB_TQL_QUERY****"

ucmdb_auth_uri = ucmdb_root_url_and_port + "/rest-api/authenticate"
ucmdb_topology_uri = ucmdb_root_url_and_port + "/rest-api/topology"

task = {"username":ucmdb_user,"password":ucmdb_password,"clientContext":1}
authresp = requests.post(ucmdb_auth_uri, json=task, verify=False)

authjsonReturn = authresp.json()
authParsedValue = authjsonReturn['token']
auth_value = "'Authorization': 'Bearer " + authParsedValue +"'"
auth_cookie = "{" + auth_value + "}"
dict_auth = ast.literal_eval(auth_cookie)

topologyresp = requests.post(ucmdb_topology_uri, headers=dict_auth, data=ucmdb_tql_query, verify=False)
topologyjsonReturn = topologyresp.json()
topologyjsonReturnformatted = json.dumps(topologyresp)

print(topologyjsonReturnformatted)
