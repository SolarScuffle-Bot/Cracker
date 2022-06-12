```lua
Module.ExitBuffer(TransitionName: TransitionName_t, Entities: { Entity_t })
```
Removes all entities from the specified from-states and adds them to all to-states but cancels entirely if OnExitBuffer(Buffer) is truthy. Ignores any states that do not exist when removing.
<br /><br />

```lua
--Everyone who might be dead sure is now :D
Cracker.ExitBuffer("Dies")
```