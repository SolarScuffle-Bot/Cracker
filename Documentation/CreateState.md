```lua
Module.CreateState(StateName: StateName_t, StateTemplate: StateTemplate_t?)
```
Creates a state with StateName and the properties in StateTemplate.
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