tool
extends EditorPlugin

var import_plugin = null


func get_plugin_name():
    return "Spritesheet To SpriteFrames Importer"


func _enter_tree():
    import_plugin = preload("spritesheet_to_spriteframes_importer.gd").new()
    add_import_plugin(import_plugin)


func _exit_tree():
    remove_import_plugin(import_plugin)
    import_plugin = null
