```lua
Module.IsInState(StateName: StateName_t, Entity: Entity_t)
```
Returns whether the entity is in the state or not.
<br /><br />

```lua
if Cracker.IsInState("Dead", Entities.BillyBobJoeNoodleMan) then
    --We do not reserve our standards for peak efficiency
    Cracker.EnterStates({ "Slacking" }, { Entities.BillyBobJoeNoodleMan })
end
```