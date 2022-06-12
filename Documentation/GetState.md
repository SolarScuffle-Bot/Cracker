```lua
Module.GetState(StateName: StateName_t) -> State_t?
```
Returns the state instance. (Only recommended for debugging use)
<br /><br />

```lua
--Make sure BillyBobJimNoodleMan has died (he was killed)
local DeadState = Cracker.GetState("Dead")
warn(DeadState.Collection)
```