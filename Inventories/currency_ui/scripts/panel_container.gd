extends PanelContainer
class_name CurrencyDisplay


@onready var count: Label = %count
enum Base {MISSION, BASE}
@export var pos: Base
enum Heads{MONEY, MANTIS, HUNDRED,REDMANTIS,CHROBUS}
@export var headtype : Heads

func _process(delta: float) -> void:
	match pos:
		Base.MISSION:
			match headtype:
				Heads.MANTIS:
					count.text = str(GlobalCurrency.mantis_heads_current)
				Heads.HUNDRED:
					count.text = str(GlobalCurrency.hundred_heads_current)
				Heads.REDMANTIS:
					count.text = str(GlobalCurrency.mantis_red_heads_current)
				Heads.MONEY:
					count.text = str(GlobalCurrency.coins)
				Heads.CHROBUS:
					count.text = str(GlobalCurrency.chrobus_heads_current)
		Base.BASE:
			match headtype:
				Heads.MANTIS:
					count.text = str(GlobalCurrency.mantis_heads)
				Heads.HUNDRED:
					count.text = str(GlobalCurrency.hundred_heads)
				Heads.REDMANTIS:
					count.text = str(GlobalCurrency.mantis_red_heads)
				Heads.MONEY:
					count.text = str(GlobalCurrency.coins)
				Heads.CHROBUS:
					count.text = str(GlobalCurrency.chrobus_heads)
