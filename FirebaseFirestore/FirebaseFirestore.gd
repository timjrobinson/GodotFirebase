extends Node

signal listed_documents(documents)

var base_url = "https://firestore.googleapis.com/v1/"
var extended_url = "projects/[PROJECT_ID]/databases/(default)/documents/"

var config = {
"apiKey": "AIzaSyASl4kfVtX8utUVc9jl-3W88mZxievAPQw",
"authDomain": "asterizzle.firebaseapp.com",
"databaseURL": "https://asterizzle.firebaseio.com",
"projectId": "asterizzle",
"storageBucket": "asterizzle.appspot.com",
"messagingSenderId": "490821403269" }

var collections = {}
var auth
var request_list_node

func _ready():
    extended_url = extended_url.replace("[PROJECT_ID]", config.projectId)
    FirebaseAuth.connect("login_succeeded", self, "on_login_succeeded")
    request_list_node = HTTPRequest.new()
    request_list_node.connect("request_completed", self, "on_list_request_completed")
    
func collection(path):
    if !collections.has(path):
        var coll = preload("res://addons/FirebaseFirestore/FirebaseFirestoreCollection.gd")
        var node = Node.new()
        node.set_script(coll)
        node.extended_url = extended_url
        node.base_url = base_url
        node.config = config
        node.auth = auth
        node.collection_name = path
        collections[path] = node
        add_child(node)
        return node
    else:
        return collections[path]

func list(path):
    if path:
        var url = base_url + extended_url + path + "?auth=" + auth.idtoken
        request_list_node.request(url, PoolStringArray(), true, HTTPClient.METHOD_GET)

func on_list_request_completed(result, response_code, headers, body):
    pass

func on_login_succeeded(auth_result):
    auth = auth_result
    for collection in collections:
        collection.auth = auth
    pass
    