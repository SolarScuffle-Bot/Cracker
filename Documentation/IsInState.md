```lua
Module.IsInState(StateName: StateName_t, Entity: Entity_t)
```
Returns whether the entity is in the state or not.
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

if Cracker.IsInState("Dead", Entities.BillyBobJoeNoodleMan) then
    --We do not reserve our standards for peak efficiency
    Cracker.EnterStates({ "Slacking" }, { Entities.BillyBobJoeNoodleMan })
end
```