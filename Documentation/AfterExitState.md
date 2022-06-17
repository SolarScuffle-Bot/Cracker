```lua
State.AfterExitState(Entities: Array<Entity_t>)
```
Called in ExitState after all entities are removed from the state.
<br /><br />

```lua
local GuardAlertBoost = 0.2
local BoostAmount = 3

Cracker.CreateState("Alerting", {
    BeforeExitState = function(Entities)
        print("The guards have been shouting as long as they can, or have they?")

        if math.random > GuardAlertBoost then return end

        task.delay(BoostAmount, function()
            Cracker.ExitStates({ "Alerting" }, { Entity })
        end)

        return true
    end;

    AfterExitState = function(Entities)
        print("They won't be screaming for a while now")
    end;
})
```