@tool
extends EditorPlugin


func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass

const ACTION_NAME = "Build and publish to itch"

func _enter_tree():
	add_tool_menu_item(ACTION_NAME, build_and_publish)

func _exit_tree():
	remove_tool_menu_item(ACTION_NAME)

const godot_exe = "Godot_v4.6-stable_win64.exe"
const itch_project = "namespacev/unmasked"

func build_and_publish():

	var project_path = ProjectSettings.globalize_path("res://")

	print("Running build and publish for ", project_path)

	print("WEB")

	var out = []
	var commands = [
		"/c",
		"cd \"%s\"" % [project_path],
		"&& "+godot_exe+" --headless --export-debug \"Web\" export/web/index.html"
	]
	await get_tree().create_timer(0.1).timeout
	OS.execute("cmd",commands,out)

	print("Creating a zip archive ")
	commands = [
		"/c",
		"cd \"%s\"" % [project_path],
		"&& 7z a export/web.zip ./export/web/*"
	]
	await get_tree().create_timer(0.1).timeout
	OS.execute("cmd",commands,out)

	print("Uploading to itch")
	commands = [
		"/c",
		"cd \"%s\"" % [project_path],
		"&& butler.exe push export/web.zip "+itch_project+":web"
	]
	await get_tree().create_timer(0.1).timeout
	OS.execute("cmd",commands,out)

	print("WIN")

	commands = [
		"/c",
		"cd \"%s\"" % [project_path],
		"&&  "+godot_exe+" --headless --export-debug \"Win\" export/win/unmasked.exe"
	]
	await get_tree().create_timer(0.1).timeout
	OS.execute("cmd",commands,out)

	print("Creating a zip archive ")
	commands = [
		"/c",
		"cd \"%s\"" % [project_path],
		"&& 7z a export/win.zip ./export/win/*"
	]
	await get_tree().create_timer(0.1).timeout
	OS.execute("cmd",commands,out)

	print("Uploading to itch")
	commands = [
		"/c",
		"cd \"%s\"" % [project_path],
		"&& butler.exe push export/win.zip "+itch_project+":win"
	]
	await get_tree().create_timer(0.1).timeout
	OS.execute("cmd",commands,out)

	print("Export done")
