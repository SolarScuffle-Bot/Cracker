```lua
Module.ExitBuffer(TransitionName: TransitionName_t, Entities: Array<Entity_t>, DontExitStates)
```
Removes all entities from the specified from-states and adds them to all to-states but cancels entirely if OnExitBuffer(Buffer) is truthy. Ignores any states that do not exist when removing. If DontExitStates is true the entities will not be removed from their previous states.
<br /><br />

```lua
--Everyone who might be dead sure is now :D
Cracker.ExitBuffer("Dies")
```