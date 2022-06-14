```lua
Module.ExitAllStates(Entities: { Entity_t })
```
Removes each entity from all states.
<br /><br />

```lua
local Entities = {    
    --The man, the myth, the legend himself:
    BillyBobJimNoodleMan = {
        AlertingTime = 5; --5 Seconds
        DetectionFailChance = 0.2; --20%
        FavoriteFood = "Noodles"; --Specifically Ramen Noodles
    };
}

--BillyBobJimNoodleMan has noclipped into the Backrooms and no longer exists in any state (rest in peace)
Cracker.ExitAllStates({ Entities.BillyBobJimNoodleMan })
```