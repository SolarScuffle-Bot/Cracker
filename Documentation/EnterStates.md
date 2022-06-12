```lua
Module.EnterStates(StateNames: { StateName_t }, Entities: { Entity_t })
```
Adds each entity to each state in StateNames. Creates any states that do not exist.
<br /><br />

```lua
local Entities = {
    Romeo = {
        AlertingTime = 2; --2 Seconds
        DetectionFailChance = 0.3; --30%
    };

    Juliette = {
        AlertingTime = 6; --6 Seconds
        DetectionFailChance = 0.4; --40%
    };
    
    --The man, the myth, the legend himself:
    BillyBobJimNoodleMan = {
        AlertingTime = 5; --5 Seconds
        DetectionFailChance = 0.2; --20%
        FavoriteFood = "Noodles"; --Specifically Ramen Noodles
    };
}

--Initialize the entity states
Crakcer.EnterStates({ "Guarding" }, { Entities.Romeo })
Cracker.EnterStates({ "Patrolling" }, { Entities.Juliette })
Cracker.EnterStates({ "Guarding", "Slacking" }, { Entities.BillyBobJimNoodleMan })
```