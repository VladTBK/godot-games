extends Node2D

@export var coin_scene: PackedScene
@export var playtime: int = 30

var level: int = 1
var score: int = 0
var coin_number: int = 5
var time_left: int = 0
var screensize: Vector2i = Vector2.ZERO
var playing: bool = false
var player: CharacterBody2D


func _ready() -> void:
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()


func _process(_delta: float) -> void:
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
		coin_number += 5
		spawn_coins(coin_number)


func new_game() -> void:
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	spawn_coins(coin_number)
	$HUD.update_score(score)
	$HUD.update_timer(time_left)


func spawn_coins(_coin_number: int) -> void:
	for i: int in _coin_number:
		var coin: Node = coin_scene.instantiate()
		coin.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
		add_child(coin)


func game_over() -> void:
	playing = false
	$GameTimer.stop()
	get_tree().call_group("coins", "queue_free")
	$HUD.show_game_over()
	$Player.die()


func _on_game_timer_timeout() -> void:
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()


func _on_player_pickup() -> void:
	score += 1
	$HUD.update_score(score)
	pass  # Replace with function body.


func _on_player_hurt() -> void:
	game_over()


func _on_hud_start_game() -> void:
	new_game()
	pass  # Replace with function body.
