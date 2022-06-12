```lua
State.OnEnterState(Entities: { Entity_t })
```
Called during EnterState before all entities are added into the state. If it returns a truthy value it prevents any entities from being added.
<br /><br />

```lua
Cracker.CreateState("Alerting", {
    OnEnterState = function(Entities)
        for _, Entity in ipairs(Entities) do
            task.delay(Entity.AlertingTime, function()
                --Stop alerting the others now
                Cracker.ExitStates({ "Alerting" }, { Entity })
            end)
        end
    end;
})
```