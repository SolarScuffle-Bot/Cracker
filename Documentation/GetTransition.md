```lua
Module.GetTransition(TransitionName: TransitionName_t) -> Transition_t
```
Gets the transition instance but errors if it doesn't exist. (Only recommended for debugging use)
<br /><br />

```lua
--Check if BillyBobJimNoodleMan made it into the buffer (he is dead)
local DetectsEnemyTransition = Cracker.GetTransition("DetectsEnemy")
warn(DetectsEnemyTransition.Buffer)
```