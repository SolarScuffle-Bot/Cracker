```lua
Module.PassBuffer(TransitionName: TransitionName_t, Entities: { Entity_t })
```
Immediately passes the entities into and out of the buffer. A shorthand for calling EnterBuffer and then ExitBuffer right after.
<br /><br />

```lua
--Without any time to react, BillyBobJimNoodleMan instantly disintegrates and dies on the spot
Cracker.PassBuffer("Dies", { Entities.BillyBobJimNoodleMan })
```