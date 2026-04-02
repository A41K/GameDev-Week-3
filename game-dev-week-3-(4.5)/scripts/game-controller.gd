extends Node

var total_coins: int = 0
var saved_coins: int = 0

func save_coins():
	saved_coins = total_coins

func reset_coins():
	total_coins = saved_coins
	# Emit signal if we need UI to update when reset occurs
	EventController.emit_signal("coin_collected", total_coins)

func coin_collected(value: int):
	total_coins += value
	EventController.emit_signal("coin_collected", total_coins)
