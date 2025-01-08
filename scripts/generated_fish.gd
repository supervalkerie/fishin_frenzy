extends Node2D

@export var fish_data = FishData
@export var fish_datas:Array[FishData]

var fish_name:String
var fish_sprite:Texture2D
var fish_weight:float
var fish_price:float

func _ready() -> void:
	
	# set fish_data to a random fish resource based on this pseudo-random weight rng
	fish_data = get_weight()
	
	# set all fish variables to the generated fish resource
	fish_name = fish_data.fish_name
	self.name = fish_name
	$Name_Label.text = fish_name
	
	fish_sprite = fish_data.fish_sprite
	$Sprite2D.texture = fish_sprite
	
	fish_weight = fish_data.fish_weight
	$Weight_Label.text = str(fish_weight) + " kg"
	
	fish_price = fish_data.fish_price
	$Price_Label.text = "$ " + str(fish_price)

# pseudo-random generator based on weights from https://stackoverflow.com/questions/1761626/weighted-random-numbers
# sum all the weights together
# generate a random number between 0 and the sum
# loop through all indexes, if the random number is less than the current index rarity, choose that
# otherwise, just subtract that rarity from the rng, and repeat
# this means lower values like 1=super rare, while high values like 10=common
func get_weight() -> FishData:
	var sum_of_weight:int = 0
	var num_of_choices:int = fish_datas.size()
	
	for i in num_of_choices:
		sum_of_weight += fish_datas[i].fish_rarity
	#print("sum: ", sum_of_weight)
	
	var rng:int = randi_range(0, sum_of_weight)
	#print("rng is ", rng)
	for n in num_of_choices:
		if rng < fish_datas[n].fish_rarity:
			print("Success! Caught: ", fish_datas[n].fish_name, ", Rarity: ", fish_datas[n].fish_rarity)
			return fish_datas[n]
		#print(rng, " ", fish_datas[n].fish_rarity)
		rng -= fish_datas[n].fish_rarity
	return fish_datas[14] # this is a null check failure? it shouldnt even return this, but instead of null
	# i just choose to return the last item on the list ie. starfish

func play_anim():
	$AnimationPlayer.play("caught_fish")
