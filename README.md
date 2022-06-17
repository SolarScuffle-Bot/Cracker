# Cracker
The data-oriented finite-state-machine as described in the Data Oriented Design book implemented in Luau. https://www.dataorienteddesign.com/dodmain/node8.html

## API

### Data Types
```lua
type TransitionName_t = any --Used to access your transitions
```

```lua
type Entity_t = any --Literally anything you want to put into the state machine
```

```lua
type Buffer_t = { Entity_t } --The array of entities that want to complete the transition
```

```lua
type StateName_t = any --Used to access your states
```

```lua
type StateTemplate_t = {    
    BeforeEnterState  : ({ Entity_t })? -> nil; 
    beforeEnterState  : ({ Entity_t })? -> nil; --Called after the entities that are already in the state have been filtered out and the rest are ready to enter the state, if it returns a truthy value the entities will not be inserted into the state (Many different allowed versions to accomodate common casings)
    before_enter_state: ({ Entity_t })? -> nil;

    AfterEnterState  : ({ Entity_t })? -> nil; 
    afterEnterState  : ({ Entity_t })? -> nil; --Called after the entities have entered the state (Many different allowed versions to accomodate common casings)
    after_enter_state: ({ Entity_t })? -> nil;

    BeforeExitState  : ({ Entity_t })? -> nil;
    beforeExitState  : ({ Entity_t })? -> nil; --Called after the entities that are not in the state have been filtered out and the rest are ready to exit the state, if it returns a truthy value the entities will not exit from the state (Many different allowed versions to accomodate common casings)
    before_exit_state: ({ Entity_t })? -> nil;

    AfterExitState  : ({ Entity_t })? -> nil;
    afterExitState  : ({ Entity_t })? -> nil; --Called after the entities have exited the state (Many different allowed versions to accomodate common casings)
    after_exit_state: ({ Entity_t })? -> nil;
};
```

```lua
type State_t = {
    Collection: { [Entity_t]: true }; --The lookup table entities are stored in
    
    BeforeEnterState: ({ Entity_t }) -> nil; --The BeforeEnterState callback you optionally defined
    AfterEnterState : ({ Entity_t }) -> nil; --The AfterEnterState callback you optionally defined

    BeforeExitState: ({ Entity_t }) -> nil;  --The OnExitState callback you optionally defined
    AfterExitState : ({ Entity_t }) -> nil;  --The OnExitState callback you optionally defined
};
```

```lua
type TransitionTemplate_t = {
    FromOr : { StateName_t }?;
    fromOr : { StateName_t }?; --The entities must be in any of the states in this array to be allowed to enter the buffer. If empty it will be ignored (Allowing many different versions to accomodate common casings)
    from_or: { StateName_t }?;
    
    FromAnd : { StateName_t }?;
    fromAnd : { StateName_t }?; --The entities must be in all of the states in this array to be allowed to enter the buffer . If empty it will be ignored(Allowing many different versions to accomodate common casings)
    from_and: { StateName_t }?;

    FromNot : { StateName_t }?;
    fromNot : { StateName_t }?; --The entities must be in none of states in this array to be allowed to enter the buffer. If empty it will be ignored (Allowing many different versions to accomodate common casings)
    from_not: { StateName_t }?;
    
    To: { StateName_t }?; --The entities will go to all of these states when they exit the buffer (Allowing many different versions to accomodate common casings)
    to: { StateName_t }?;
    
    BeforeEnterBuffer  : (Entity_t)? -> bool?;
    beforeEnterBuffer  : (Entity_t)? -> bool?; --Called right before an entity enters the buffer, if it returns a truthy value the entity will not be inserted into the buffer (Allowing many different versions to accomodate common casings)
    before_enter_buffer: (Entity_t)? -> bool?;

    AfterEnterBuffer  : (Entity_t)? -> bool?;
    afterEnterBuffer  : (Entity_t)? -> bool?; --Called right after an entity enters the buffer (Allowing many different versions to accomodate common casings)
    after_enter_buffer: (Entity_t)? -> bool?;

    BeforeExitBuffer  : (Buffer_t)? -> bool?;
    beforeExitBuffer  : (Buffer_t)? -> bool?; --Called at the beginning of ExitBuffer, if it returns a truthy value it returns early and nothing happens to the buffer or entities (Allowing many different versions to accomodate common casings)
    before_exit_buffer: (Buffer_t)? -> bool?;

    AfterExitBuffer  : (Buffer_t)? -> bool?;
    afterExitBuffer  : (Buffer_t)? -> bool?; --Called at the end of ExitBuffer (Allowing many different versions to accomodate common casings)
    after_exit_buffer: (Buffer_t)? -> bool?;
}
```

```lua
type Transition_t = {
    Buffer: Buffer_t; --The array that entities are stored in before exiting their old states and entering their new ones
    
    FromOr: { StateName_t }; --The entities must be in any of these states to be allowed to enter the buffer
    
    FromAnd: { StateName_t }; --The entities must be in all of these states to be allowed to enter the buffer. If empty it will be ignored

    FromNot: { StateName_t };  --The entities must be in none of these states to be allowed to enter the buffer. If empty it will be ignored

    To: { StateName_t }; --The entities will go to all of these states when they exit the buffer. If empty it will be ignored
    
    BeforeEnterBuffer: (Entity_t) -> bool?; --The BeforeEnterBuffer callback you optionally defined
    AfterEnterBuffer : (Entity_t) -> bool?; --The AfterEnterBuffer callback you optionally defined

    BeforeExitBuffer: (Buffer_t) -> bool?; --The BeforeExitBuffer callback you optionally defined
    AfterExitBuffer : (Buffer_t) -> bool?; --The AfterExitBuffer callback you optionally defined
}
```

### Methods
```lua
Module.CreateTransition(TransitionName: TransitionName_t, TransitionTemplate: Template_t)
```
[Example](./Documentation/CreateTransition.md)<br />
Creates a transition with TransitionName and the properties in TransitionTemplate.
<br /><br />

```lua
Module.DeleteTransition(TransitionName: TransitionName_t)
```
[Example](./Documentation/DeleteTransition.md)<br />
Clears the transition's buffer and deletes it.
<br /><br />

```lua
Module.GetTransition(TransitionName: TransitionName_t) -> Transition_t
```
[Example](./Documentation/GetTransition.md)<br />
Gets the transition instance but errors if it doesn't exist. (Only recommended for debugging use)
<br /><br />

```lua
Module.CreateState(StateName: StateName_t, StateTemplate: StateTemplate_t?)
```
[Example](./Documentation/CreateState.md)<br />
Creates a state with StateName and the properties in StateTemplate.
<br /><br />

```lua
Module.GetState(StateName: StateName_t) -> State_t?
```
[Example](./Documentation/GetState.md)<br />
Returns the state instance. (Only recommended for debugging use)
<br /><br />

```lua
Module.EnterStates(StateNames: { StateName_t }, Entities: { Entity_t })
```
[Example](./Documentation/EnterStates.md)<br />
Adds each entity to each state in StateNames. Creates any states that do not exist.
<br /><br />

```lua
Module.ExitStates(StateNames: { StateName_t }, Entities: { Entity_t })
```
[Example](./Documentation/ExitStates.md)<br />
Removes each entity from each state in StateNames. Ignores any states that do not exist.
<br /><br />

```lua
Module.ExitAllStates(Entities: { Entity_t })
```
[Example](./Documentation/ExitAllStates.md)<br />
Removes each entity from all states.
<br /><br />

```lua
Module.IsInState(StateName: StateName_t, Entity: Entity_t)
```
[Example](./Documentation/IsInState.md)<br />
Returns whether the entity is in the state or not.
<br /><br />

```lua
Module.EnterBuffer(TransitionName: TransitionName_t, Entities: { Entity_t })
```
[Example](./Documentation/EnterBuffer.md)<br />
Inserts each entity if it is in the specified from-states but cancels before inserting if OnEnterBuffer(Entity) is truthy. Creates any states that do not exist when adding.
<br /><br />

```lua
Module.ExitBuffer(TransitionName: TransitionName_t, Entities: { Entity_t })
```
[Example](./Documentation/ExitBuffer.md)<br />
Removes all entities from the specified from-states and adds them to all to-states but cancels entirely if OnExitBuffer(Buffer) is truthy. Ignores any states that do not exist when removing.
<br /><br />

```lua
Module.PassBuffer(TransitionName: TransitionName_t, Entities: { Entity_t })
```
[Example](./Documentation/PassBuffer.md)<br />
Entities pass right past the buffer and immediately switch states.
<br /><br />

```lua
Module.ThroughBuffer(TransitionName: TransitionName_t, Entities: { Entity_t })
```
[Example](./Documentation/ThroughBuffer.md)<br />
Immediately passes the entities into and out of the buffer. A shorthand for calling EnterBuffer and then ExitBuffer right after.
<br /><br />

```lua
Module.DebugText() -> string
```
[Example](./Documentation/DebugText.md)<br />
Returns a string of useful debugging information.
<br /><br />

```lua
Transition.BeforeEnterBuffer(Entity: Entity_t) -> bool?
```
[Example](./Documentation/BeforeEnterBuffer.md)<br />
Called in EnterBuffer before each entity is inserted to the buffer. If it returns a truthy value it prevents the entity from being inserted.
<br /><br />

```lua
Transition.AfterEnterBuffer(Entity: Entity_t) -> bool?
```
[Example](./Documentation/AfterEnterBuffer.md)<br />
Called in EnterBuffer after each entity is inserted to the buffer.
<br /><br />


```lua
Transition.BeforeExitBuffer(Buffer: Buffer_t) -> bool?
```
[Example](./Documentation/BeforeExitBuffer.md)<br />
Called in ExitBuffer before anything happens. If it returns a truthy value it prevents anything from happening.
<br /><br />

```lua
Transition.AfterExitBuffer(Buffer: Buffer_t) -> bool?
```
[Example](./Documentation/AfterExitBuffer.md)<br />
Called in ExitBuffer before anything happens. If it returns a truthy value it prevents anything from happening.
<br /><br />

```lua
State.BeforeEnterState(Entities: { Entity_t })
```
[Example](./Documentation/BeforeEnterState.md)<br />
Called during EnterState before all entities are added into the state. If it returns a truthy value it prevents any entities from being added.
<br /><br />

```lua
State.AfterEnterState(Entities: { Entity_t })
```
[Example](./Documentation/AfterEnterState.md)<br />
Called during EnterState after all entities are added into the state.
<br /><br />

```lua
State.BeforeExitState(Entities: { Entity_t })
```
[Example](./Documentation/BeforeExitState.md)<br />
Called in ExitState before all entities are removed from the state. If it returns a truthy value it prevents any entities from being removed.
<br /><br />

```lua
State.AfterExitState(Entities: { Entity_t })
```
[Example](./Documentation/AfterExitState.md)<br />
Called in ExitState after all entities are removed from the state.
<br /><br />