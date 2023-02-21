# Prolog adventure game

## Implementation


###    Enemies
Over 20 different enemies. They vary in hp, damage, and speed and
that splits them to 4 strength tiers:
<ul>
  <li style="color:grey;">Weak</li>
  <li style="color:lightblue;">Strong</li>
  <li style="color:red;">Demon</li>
  <li style="color:gold;">Ancient Demigods</li>
</ul>  

### Items
Over 30 different items of 4 tiers:
    <ul>
  <li style="color:grey;">Common</li>
  <li style="color:lightblue;">Uncommon</li>
  <li style="color:red;">Legendary</li>
  <li style="color:gold;">Godly</li>
</ul>  


<b>The stats of both items and entities are dynamicaly scaled based on the progression to keep the game more interesting.</b>
### Map
Map is heavily inspired by the urban legend backrooms.
There are 8 "rooms" coresponding to the first 7 backroom levels.
Since the backrooms are a non euclidean space, the connections between levels are pretty much random. Going north and then south will leave you somewhere completly different.

### Player inventory
Tracks items that the player has found and their quantity. 


## Example usage
Game is split into multiple .pl files. To launch use : ``` swipl game.pl```.

Start the game by either ```start().``` or ```godMode().```

Now when done with reading type anything such as ```a.``` to continue.

The game begins and your player will start wandering around the endless level
for a few 10ths of a second before he will find himself in a hallway. During this time two random events can occur player can occur.
The player will either finds a chest and automatically loots it. The name of the item will be written in the color representing the quality. Hp and Speed stack so every item picked up just adds more to them. While damage does not scale so only the best one is used.

Or the player can encounter an Entity after which he can decide to either
flee ```n.``` while being chased by it, or to fight ```y.``` Entities are also colored by their strenght, but their full stats are never shown so the player has to make his judments based on partial information. After deciding the full stats are shown and a 5 second window is present to contamplate.
If the player won the fight, he will loot another chest that the entity was guarding, if he lost, he dies and the game ends.
If the player succesfully escaped, nothing will happen, while if he does not he will die, resulting in the game ending.

After the player finished wandering, he will be met with a decision to choose the direction to go to by calling the ```north(), south(), east() or west()``` method. Remember, this is non euclidian space so path could lead anywhere.
To win the player has to wander around his way to level 8 while fighting trough
stronger and stronger enemies.




<image size=800% src="Images/showcase.png">

