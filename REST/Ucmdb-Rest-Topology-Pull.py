import string
import requests
import ast 

task = {"username":"****UCMDB_USER****","password":"****UCMDB_PASSWORD****","clientContext":1}
authresp = requests.post('https://****UCMDB_HOST****:****UCMDB_PORT****/rest-api/authenticate', json=task, verify=False)
authjsonReturn = authresp.json()
authParsedValue = authjsonReturn['token']
auth_value = "'Authorization': 'Bearer " + authParsedValue +"'"
auth_cookie = "{" + auth_value + "}"
dict_auth = ast.literal_eval(auth_cookie)
tql_query = "****UCMDB_TQL_QUERY****"
topologyresp = requests.post('https://****UCMDB_HOST****:****UCMDB_PORT****/rest-api/topology', headers=dict_auth, data=tql_query, verify=False)
topologyjsonReturn = topologyresp.json()
print(topologyjsonReturn)