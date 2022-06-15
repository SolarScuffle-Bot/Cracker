```lua
Module.ThroughBuffer(TransitionName: TransitionName_t, Entities: { Entity_t })
```
Immediately enters and exits the entities right through the buffer. A shorthand for calling EnterBuffer and then ExitBuffer right after.
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

--With potential exception, without any time to react BillyBobJimNoodleMan instantly disintegrates and dies on the spot.
Cracker.ThroughBuffer("Dies", { Entities.BillyBobJimNoodleMan })
```