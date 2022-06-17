```lua
Module.EnterBuffer(TransitionName: TransitionName_t, Entities: Array<Entity_t>)
```
Inserts each entity if it is in the specified from-states but cancels before inserting if OnEnterBuffer(Entity) is truthy. Creates any states that do not exist.
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

--BillyBobJimNoodleMan might have died!
Cracker.EnterBuffer("Dies", { Entities.BillyBobJimNoodleMan })
```