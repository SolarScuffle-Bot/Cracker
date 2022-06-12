```lua
Module.EnterBuffer(TransitionName: TransitionName_t, Entities: { Entity_t })
```
Inserts each entity if it is in the specified from-states but cancels before inserting if OnEnterBuffer(Entity) is truthy. Creates any states that do not exist.
<br /><br />

```lua
--Everyone who might be dead sure is now :D
Cracker.ExitBuffer("Dies")
```