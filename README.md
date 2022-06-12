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
    OnEnterState  : ({ Entity_t })? -> nil; 
    onEnterState  : ({ Entity_t })? -> nil; --Called after the entities that are already in the state have been filtered out and the rest are ready to enter the state. (Many different allowed versions to accomodate common casings)
    on_enter_state: ({ Entity_t })? -> nil;

    OnExitState  : ({ Entity_t })? -> nil;
    onExitState  : ({ Entity_t })? -> nil; --Called after the entities that are not in the state have been filtered out and the rest are ready to exit the state (Many different allowed versions to accomodate common casings)
    on_exit_state: ({ Entity_t })? -> nil;
};
```

```lua
type State_t = {
    Collection: { [Entity_t]: true }; --The lookup table entities are stored in
    
    OnEnterState: ({ Entity_t }) -> nil; --The OnEnterState callback you optionally defined

    OnExitState: ({ Entity_t }) -> nil;  --The OnExitState callback you optionally defined
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
    
    OnEnterBuffer  : (Entity_t)? -> bool?;
    onEnterBuffer  : (Entity_t)? -> bool?; --Called right before an entity enters the buffer, if it returns a truthy value the entity will not be inserted into the buffer (Allowing many different versions to accomodate common casings)
    on_enter_buffer: (Entity_t)? -> bool?;

    OnExitBuffer  : (Buffer_t)? -> bool?;
    onExitBuffer  : (Buffer_t)? -> bool?; --Called at the beginning of ExitBuffer, if it returns a truthy value it returns early and nothing happens to the buffer or entities (Allowing many different versions to accomodate common casings)
    on_exit_buffer: (Buffer_t)? -> bool?;
}
```

```lua
type Transition_t = {
    Buffer: Buffer_t; --The array that entities are stored in before exiting their old states and entering their new ones
    
    FromOr: { StateName_t }; --The entities must be in any of these states to be allowed to enter the buffer
    
    FromAnd: { StateName_t }; --The entities must be in all of these states to be allowed to enter the buffer. If empty it will be ignored

    FromNot: { StateName_t };  --The entities must be in none of these states to be allowed to enter the buffer. If empty it will be ignored

    To: { StateName_t }; --The entities will go to all of these states when they exit the buffer. If empty it will be ignored
    
    OnEnterBuffer: (Entity_t) -> bool?; --The OnEnterBuffer callback you optionally defined

    OnExitBuffer: (Buffer_t) -> bool?; --The OnExitBuffer callback you optionally defined
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
Immediately passes the entities into and out of the buffer. A shorthand for calling EnterBuffer and then ExitBuffer right after.
<br /><br />

```lua
Module.DebugText() -> string
```
[Example](./Documentation/DebugText.md)<br />
Returns a string of useful debugging information.
<br /><br />

```lua
Transition.OnEnterBuffer(Entity: Entity_t) -> bool?
```
[Example](./Documentation/OnEnterBuffer.md)<br />
Called in EnterBuffer before each entity is inserted to the buffer. If it returns a truthy value it prevents the entity from being inserted.
<br /><br />

```lua
Transition.OnExitBuffer(Buffer: Buffer_t) -> bool?
```
[Example](./Documentation/OnExitBuffer.md)<br />
Called in ExitBuffer before anything happens. If it returns a truthy value it prevents anything from happening.
<br /><br />

```lua
State.OnEnterState(Entities: { Entity_t })
```
[Example](./Documentation/OnEnterState.md)<br />
Called during EnterState before all entities are added into the state. If it returns a truthy value it prevents any entities from being added.
<br /><br />

```lua
State.OnExitState(Entities: { Entity_t })
```
[Example](./Documentation/OnExitState.md)<br />
Called in ExitState before all entities are removed from the state. If it returns a truthy value it prevents any entities from being removed.
<br /><br />