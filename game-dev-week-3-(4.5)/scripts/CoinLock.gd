extends Area2D

@export var required_coins: int = 3
@export_file("*.tscn") var target_scene_path: String = "res://scenes/level_3.tscn"

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return

	if GameController.total_coins < required_coins:
		print("It's locked")
		return

	if target_scene_path.is_empty():
		print("Unlocked, but no target scene is assigned.")
		return

	GameController.save_coins()
	get_tree().call_deferred("change_scene_to_file", target_scene_path)
