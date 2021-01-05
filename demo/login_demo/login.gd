extends Control

var firestore_collection

# Function called when the scene is ready
# Connects the two functions to the Firebase login
# Function checks if there is an encrypted user file and tries to refresh the token is it finds one
func _ready():
	Firebase.Auth.connect("login_succeeded", self, "_on_FirebaseAuth_login_succeeded")
	Firebase.Auth.connect("login_failed", self, "on_login_failed")
	check_encrypted_auth_token()

# Function called when the login button is pressed
# This will pull the data from the email and password fields and use Firebase to login
# Will call _on_FirebaseAuth_login_succeeded or on_login_failed when complete
func _on_login_pressed():
	var email = $main/user_info/VBoxContainer/email_rect/email.text
	var password = $main/user_info/VBoxContainer/password_rect/password.text
	Firebase.Auth.login_with_email_and_password(email, password)

# Function called when the login button is pressed
# This will pull the data from the email and password fields and use Firebase register a new account
func _on_register_pressed():
	var email = $main/user_info/VBoxContainer/email_rect/email.text
	var password = $main/user_info/VBoxContainer/password_rect/password.text
	Firebase.Auth.signup_with_email_and_password(email, password)

# Function called when the remove button is pressed
# Function will call remove_encrypted_auth_token
func _on_remove_pressed():
	remove_encrypted_auth_token()

# Function called when the login to Firebase has completed successfully
# Function will then call store_encrypted_auth_token() to save the user auth data
func _on_FirebaseAuth_login_succeeded(auth):
	store_encrypted_auth_token(auth)

# Function called when the login to Firebase has failed
# Function will print the error to the console
func on_login_failed(error_code, message):
	print("error code: " + str(error_code))
	print("message: " + str(message))

# This function will store an encrypted file of the user's auth token with a unique ID genetred by the OS
# Note that OS.get_unique_id() does not work on UWP or HTML5
func store_encrypted_auth_token(auth):
	var encrypted_file = File.new()
	encrypted_file.open_encrypted_with_pass("user://user.auth", File.WRITE, OS.get_unique_id())
	encrypted_file.store_line(to_json(auth))
	encrypted_file.close()

# Function to check if there is an encrpyted auth token file
# If there is, the game will load it and refresh the token
func check_encrypted_auth_token():
	var dir = Directory.new()
	if (dir.file_exists("user://user.auth")):
		load_encrypted_auth_token()
		pass
	else:
		print("No encrypted auth file exists")

# Function used to load the encrypted auth token
func load_encrypted_auth_token():
	var encrypted_file = File.new()
	encrypted_file.open_encrypted_with_pass("user://user.auth", File.READ, OS.get_unique_id())
	var encrypted_file_data = parse_json(encrypted_file.get_line())
	Firebase.Auth.manual_token_refresh(encrypted_file_data)	

# Function used to remove an encrypted auth token
func remove_encrypted_auth_token():
	var dir = Directory.new()
	if (dir.file_exists("user://user.auth")):
		dir.remove("user://user.auth")
		print("File removed")
	else:
		print("No encrypted auth file exists")

func on_document_get(document):
	print("I got it")

func _on_delete_pressed():
	remove_encrypted_auth_token()

func _on_connect_pressed():
	firestore_collection = Firebase.Firestore.collection('user_data')
	firestore_collection.connect("get_document", self, "on_document_get")
	var firestore_document = firestore_collection.get('document1')
