tool
extends Control

var auth
var project_url


func _ready():
    FirebaseAuth.connect("login_succeeded", self, "on_login_succeeded")
    FirebaseAuth.connect("login_failed", self, "on_login_failed")

func _on_Button_pressed():
    $Popup.show()
    print("Button pressed")

func on_login_failed():
    print("Login failed")

func _on_LOGIN_pressed():
    print("Attempting login")
    FirebaseAuth.login_with_email_and_password($Popup/VBoxContainer/Email.text, $Popup/VBoxContainer/Password.text)
    _on_Cancel_pressed()
    

func on_login_succeeded(auth_token):
    print(auth_token)
    auth = auth_token
    $VBoxContainer/Button.hide()
    $VBoxContainer/MainContainer.show()
    $Popup.hide()
    
func _on_Signup_pressed():
    print("Attempting signup")
    FirebaseAuth.signup_with_email_and_password($Popup/VBoxContainer/Email.text, $Popup/VBoxContainer/Password.text)
    _on_Cancel_pressed()


func _on_Cancel_pressed():
    $Popup/VBoxContainer/Password.text = ""
    $Popup/VBoxContainer/Email.text = ""


func _on_NewTilemap_pressed():
    var scene = load("res://addons/FirebaseDatabase/TileMapPair.tscn").instance()
    $VBoxContainer/MainContainer/TilemapContainer.add_child(scene)


func _on_Upload_pressed():
    for child in $VBoxContainer/MainContainer/TilemapContainer.get_children():
        var scene = child.get_node("Scene").text
        var tilemap_path = child.get_node("Tilemap").text
        var firebase_path = child.get_node("Firebase").text
        var firebase_name = child.get_node("Name").text
        var loaded_scene = load(scene).instance()
        var tilemap = loaded_scene.get_node(tilemap_path)
        var data = get_serialized_tilemap(tilemap)
        
        var ref = FirebaseDatabase.get_database_reference(firebase_path, {})
        ref.connect("push_successful", self, "on_pushed")
        ref.push({"name": firebase_name, "map": data})
        pass

func get_serialized_tilemap(map):
    var used_rect = map.get_used_rect()
    var serialized_map = {}
    for y in used_rect.size.y:
        for x in used_rect.size.x:
            var pos = Vector2(x, y)
            var cell = map.get_cellv(pos)
            serialized_map[pos] = cell
    
    return serialized_map

func on_pushed():
    print("Pushed")
        
