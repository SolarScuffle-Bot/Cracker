```lua
State.AfterEnterState(Entities: Array<Entity_t>)
```
[Example](./Documentation/AfterEnterState.md)<br />
Called during EnterState after all entities are added into the state.
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