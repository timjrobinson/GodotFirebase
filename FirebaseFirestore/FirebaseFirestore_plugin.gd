tool
extends EditorPlugin

func _enter_tree():
    add_autoload_singleton("FirebaseFirestore", "res://addons/FirebaseFirestore/FirebaseFirestore.gd")
    pass

func _exit_tree():
    remove_autoload_singleton("FirebaseFirestore")
    pass
