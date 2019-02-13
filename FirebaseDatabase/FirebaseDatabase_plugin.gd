tool
extends EditorPlugin

#var control = preload("res://addons/FirebaseDatabase/BackFire.tscn").instance()
func _enter_tree():
    add_autoload_singleton("FirebaseDatabase", "res://addons/FirebaseDatabase/FirebaseDatabase.gd")
    #add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UL, control)

func _exit_tree():
    remove_autoload_singleton("FirebaseDatabase")
    #remove_control_from_docks(control)
    #control.free()
