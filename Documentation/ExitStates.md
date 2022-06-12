```lua
Module.ExitStates(StateNames: { StateName_t }, Entities: { Entity_t })
```
Removes each entity from each state in StateNames. Ignores any states that do not exist.
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

--BillyBobJimNoodleMan remembered his family back in Noodle Town and stopped slacking off!
Cracker.ExitStates({ "Slacking" }, { Entities.BillyBobJimNoodleMan })
```