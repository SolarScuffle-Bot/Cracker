```lua
State.OnExitState(Entities: { Entity_t })
```
Called in ExitState before all entities are removed from the state. If it returns a truthy value it prevents any entities from being removed.
<br /><br />

```lua
Cracker.CreateState("Dead", {
    OnExitState = function(Entities)
        print(Entities, "ARE ALIVE! FROM THE HEAVENS AND BACK THEY HAVE RETURNED!")
    end;
})
```