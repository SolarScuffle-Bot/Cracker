```lua
Module.PassBuffer(TransitionName: TransitionName_t, Entities: Array<Entity_t>, DontExitStates: boolean)
```
Entities pass right past the buffer and immediately switch states. If DontExitStates is true the entities will not be removed from their previous states.
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

--No exceptions, without any time to react BillyBobJimNoodleMan instantly disintegrates and dies on the spot
Cracker.PassBuffer("Dies", { Entities.BillyBobJimNoodleMan })
```