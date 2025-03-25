extends Control
var sqlite = SQLite
var username = ""
var password
var db
var datapath = "res://data/data"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	db = sqlite.new()
	db.path = datapath
	db.open_db()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_register_button_down() -> void:
	username = $Name.text
	password = $Password.text.sha256_text()
	db.query("select user_name from users where user_name = '"+username+"'")
	if db.query_result.size()<=0:
		db.query("insert into users (user_name, password) values ('"+username+"','"+password+"')")
	pass


func _on_login_button_down() -> void:

	var found = false
	username = $Name.text
	password = $Password.text.sha256_text()
	db.query("select password from users where user_name = '"+username+"'")
	for i in range(0,db.query_result.size()):
		print(db.query_result[i]["password"])
		if db.query_result[i]["password"] == password:
			get_tree().change_scene_to_file("res://main.tscn")
		found=true
	pass # Replace with function body.
