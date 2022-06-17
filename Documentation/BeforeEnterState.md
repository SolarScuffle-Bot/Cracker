```lua
State.BeforeEnterState(Entities: Array<Entity_t>)
```
Called during EnterState before all entities are added into the state. If it returns a truthy value it prevents any entities from being added.
<br /><br />

```lua
local VoiceBoxExploded = 0.4

Cracker.CreateState("Alerting", {
    BeforeEnterState = function(Entities)
        print(Entities, "Are about to enter Alerting, make sure their voice boxes haven't exploded")

        return math.random() <= VoiceBoxExploded
    end;

    AfterEnterState = function(Entities)
        print("Voice boxes are safe, SCREAM")
        
        for _, Entity in ipairs(Entities) do
            task.delay(Entity.AlertingTime, function()
                --Stop alerting the others now
                Cracker.ExitStates({ "Alerting" }, { Entity })
            end)
        end
    end;
})
```