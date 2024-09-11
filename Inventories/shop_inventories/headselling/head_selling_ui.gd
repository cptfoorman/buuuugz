extends Control
class_name HeadSellerUI

signal EXIT

@onready var mantis: Label = %mantis
@onready var hundred: Label = %hundred
@onready var mantisred: Label = %mantisred
@onready var chrobus: Label = %chrobus

func _process(delta: float) -> void:
	mantis.text = str(GlobalCurrency.mantis_heads)
	hundred.text = str(GlobalCurrency.hundred_heads)
	mantisred.text = str(GlobalCurrency.mantis_red_heads)
	chrobus.text = str(GlobalCurrency.chrobus_heads)


func _on_mantis_5_pressed() -> void:
	if GlobalCurrency.mantis_heads >= 5:
		GlobalCurrency.mantis_heads -= 5
		GlobalCurrency.coins += 50


func _on_hundred_5_pressed() -> void:
	if GlobalCurrency.hundred_heads >= 5:
		GlobalCurrency.hundred_heads -= 5
		GlobalCurrency.coins += 100


func _on_mantisred_5_pressed() -> void:
	if GlobalCurrency.mantis_red_heads >= 5:
		GlobalCurrency.mantis_red_heads -= 5
		GlobalCurrency.coins += 150


func _on_mantis_1_pressed() -> void:
	if GlobalCurrency.mantis_heads >= 1:
		GlobalCurrency.mantis_heads -= 1
		GlobalCurrency.coins += 10


func _on_hundred_1_pressed() -> void:
	if GlobalCurrency.hundred_heads >= 1:
		GlobalCurrency.hundred_heads -= 1
		GlobalCurrency.coins += 20


func _on_mantisred_1_pressed() -> void:
	if GlobalCurrency.mantis_red_heads >= 1:
		GlobalCurrency.mantis_red_heads -= 1
		GlobalCurrency.coins += 30


func _on_exit_pressed() -> void:
	EXIT.emit()


func _on_chrobus_5_pressed() -> void:
	if GlobalCurrency.chrobus_heads >= 5:
		GlobalCurrency.chrobus_heads -= 5
		GlobalCurrency.coins += 250


func _on_chrobus_1_pressed() -> void:
	if GlobalCurrency.chrobus_heads >= 1:
		GlobalCurrency.chrobus_heads -= 1
		GlobalCurrency.coins += 50
