extends Resource
class_name Item

enum Type{WEAPON, SKILL, ITEM}

@export var item_name: String
@export var item_scene: PackedScene
@export var item_icon: Texture2D
@export var amount: int
@export var stackable: bool
@export var item_type: Type
@export var item_value: int
@export var is_c4: bool
@export var description: String
