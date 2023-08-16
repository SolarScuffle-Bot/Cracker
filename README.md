# Cracker
~~The data-oriented finite-state-machine as described in the Data Oriented Design book implemented in Luau.~~ https://www.dataorienteddesign.com/dodmain/node8.html
This library is an outdated fossil that is not practical to use in normal applications. The concepts are still useful and applicable right now in any codebase, but this code itself is substandard. 

## API

### Data Types
```lua
export type Array<T> = { [number]: T }
```

```lua
export type TransitionName_t = any
```

```lua
export type Entity_t = any
```

```lua
export type Buffer_t = Array<Entity_t>
```

```lua
export type StateName_t = any
```

```lua
export type StateTemplate_t = {    
    BeforeEnterState   : (Entities: Array<Entity_t>) -> nil; 
    beforeEnterState   : (entities: Array<Entity_t>) -> nil; --Called after the entities that are already in the state have been filtered out and the rest are ready to enter the state, if it returns a truthy value the entities will not be inserted into the state (Many different allowed versions to accomodate common casings)
    before_enter_state : (entities: Array<Entity_t>) -> nil;

    AfterEnterState   : (Entities: Array<Entity_t>) -> nil; 
    afterEnterState   : (entities: Array<Entity_t>) -> nil; --Called after the entities have entered the state (Many different allowed versions to accomodate common casings)
    after_enter_state : (entities: Array<Entity_t>) -> nil;

    BeforeExitState   : (Entities: Array<Entity_t>) -> nil;
    beforeExitState   : (entities: Array<Entity_t>) -> nil; --Called after the entities that are not in the state have been filtered out and the rest are ready to exit the state, if it returns a truthy value the entities will not exit from the state (Many different allowed versions to accomodate common casings)
    before_exit_state : (entities: Array<Entity_t>) -> nil;

    AfterExitState   : (Entities: Array<Entity_t>) -> nil;
    afterExitState   : (entities: Array<Entity_t>) -> nil; --Called after the entities have exited the state (Many different allowed versions to accomodate common casings)
    after_exit_state : (entities: Array<Entity_t>) -> nil;
}
```

```lua
export type State_t = {
    Collection : { [Entity_t]: true }; --The lookup table entities are stored in

    BeforeEnterState : (Entities: Array<Entity_t>) -> nil; --The BeforeEnterState callback you optionally defined
    AfterEnterState  : (Entities: Array<Entity_t>) -> nil; --The AfterEnterState callback you optionally defined

    BeforeExitState : (Entities: Array<Entity_t>) -> nil;  --The OnExitState callback you optionally defined
    AfterExitState  : (Entities: Array<Entity_t>) -> nil;  --The OnExitState callback you optionally defined
}
```

```lua
export type TransitionTemplate_t = {
    FromOr  : Array<StateName_t>?;
    fromOr  : Array<StateName_t>?; --The entities must be in any of the states in this array to be allowed to enter the buffer. If empty it will be ignored (Allowing many different versions to accomodate common casings)
    from_or : Array<StateName_t>?;

    FromAnd  : Array<StateName_t>?;
    fromAnd  : Array<StateName_t>?; --The entities must be in all of the states in this array to be allowed to enter the buffer . If empty it will be ignored(Allowing many different versions to accomodate common casings)
    from_and : Array<StateName_t>?;

    FromNot  : Array<StateName_t>?;
    fromNot  : Array<StateName_t>?; --The entities must be in none of states in this array to be allowed to enter the buffer. If empty it will be ignored (Allowing many different versions to accomodate common casings)
    from_not : Array<StateName_t>?;

    To : Array<StateName_t>?; --The entities will go to all of these states when they exit the buffer (Allowing many different versions to accomodate common casings)
    to : Array<StateName_t>?;

    BeforeEnterBuffer   : (Entity: Entity_t) -> boolean?;
    beforeEnterBuffer   : (entity: Entity_t) -> boolean?; --Called right before an entity enters the buffer, if it returns a truthy value the entity will not be inserted into the buffer (Allowing many different versions to accomodate common casings)
    before_enter_buffer : (entity: Entity_t) -> boolean?;

    AfterEnterBuffer   : (Entity: Entity_t) -> boolean?;
    afterEnterBuffer   : (entity: Entity_t) -> boolean?; --Called right after an entity enters the buffer (Allowing many different versions to accomodate common casings)
    after_enter_buffer : (entity: Entity_t) -> boolean?;

    BeforeExitBuffer   : (Buffer: Buffer_t) -> boolean?;
    beforeExitBuffer   : (buffer: Buffer_t) -> boolean?; --Called at the beginning of ExitBuffer, if it returns a truthy value it returns early and nothing happens to the buffer or entities (Allowing many different versions to accomodate common casings)
    before_exit_buffer : (buffer: Buffer_t) -> boolean?;

    AfterExitBuffer   : (Buffer: Buffer_t) -> boolean?;
    afterExitBuffer   : (buffer: Buffer_t) -> boolean?; --Called at the end of ExitBuffer (Allowing many different versions to accomodate common casings)
    after_exit_buffer : (buffer: Buffer_t) -> boolean?;
}
```

```lua
export type Transition_t = {
    Buffer : Buffer_t; --The array that entities are stored in before exiting their old states and entering their new ones

    FromOr : Array<StateName_t>; --The entities must be in any of these states to be allowed to enter the buffer

    FromAnd : Array<StateName_t>; --The entities must be in all of these states to be allowed to enter the buffer. If empty it will be ignored

    FromNot : Array<StateName_t>;  --The entities must be in none of these states to be allowed to enter the buffer. If empty it will be ignored

    To : Array<StateName_t>; --The entities will go to all of these states when they exit the buffer. If empty it will be ignored

    BeforeEnterBuffer : (Buffer: Entity_t) -> boolean?; --The BeforeEnterBuffer callback you optionally defined
    AfterEnterBuffer  : (Buffer: Entity_t) -> boolean?; --The AfterEnterBuffer callback you optionally defined

    BeforeExitBuffer : (Buffer: Buffer_t) -> boolean?; --The BeforeExitBuffer callback you optionally defined
    AfterExitBuffer  : (Buffer: Buffer_t) -> boolean?; --The AfterExitBuffer callback you optionally defined
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
Module.EnterStates(StateNames: Array<StateName_t>, Entities: Array<Entity_t>)
```
[Example](./Documentation/EnterStates.md)<br />
Adds each entity to each state in StateNames. Creates any states that do not exist.
<br /><br />

```lua
Module.ExitStates(StateNames: Array<StateName_t>, Entities: Array<Entity_t>)
```
[Example](./Documentation/ExitStates.md)<br />
Removes each entity from each state in StateNames. Ignores any states that do not exist.
<br /><br />

```lua
Module.ExitAllStates(Entities: Array<Entity_t>)
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
Module.EnterBuffer(TransitionName: TransitionName_t, Entities: Array<Entity_t>)
```
[Example](./Documentation/EnterBuffer.md)<br />
Inserts each entity if it is in the specified from-states but cancels before inserting if OnEnterBuffer(Entity) is truthy. Creates any states that do not exist when adding.
<br /><br />

```lua
Module.ExitBuffer(TransitionName: TransitionName_t, Entities: Array<Entity_t>, ShouldntExitStates: boolean)
```
[Example](./Documentation/ExitBuffer.md)<br />
Removes all entities from the specified from-states and adds them to all to-states but cancels entirely if OnExitBuffer(Buffer) is truthy. Ignores any states that do not exist when removing.
<br /><br />

```lua
Module.PassBuffer(TransitionName: TransitionName_t, Entities: Array<Entity_t>, ShouldntExitStates: boolean)
```
[Example](./Documentation/PassBuffer.md)<br />
Entities pass right past the buffer and immediately switch states.
<br /><br />

```lua
Module.ThroughBuffer(TransitionName: TransitionName_t, Entities: Array<Entity_t>, ShouldntExitStates: boolean)
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
State.BeforeEnterState(Entities: Array<Entity_t>)
```
[Example](./Documentation/BeforeEnterState.md)<br />
Called during EnterState before all entities are added into the state. If it returns a truthy value it prevents any entities from being added.
<br /><br />

```lua
State.AfterEnterState(Entities: Array<Entity_t>)
```
[Example](./Documentation/AfterEnterState.md)<br />
Called during EnterState after all entities are added into the state.
<br /><br />

```lua
State.BeforeExitState(Entities: Array<Entity_t>)
```
[Example](./Documentation/BeforeExitState.md)<br />
Called in ExitState before all entities are removed from the state. If it returns a truthy value it prevents any entities from being removed.
<br /><br />

```lua
State.AfterExitState(Entities: Array<Entity_t>)
```
[Example](./Documentation/AfterExitState.md)<br />
Called in ExitState after all entities are removed from the state.
<br /><br />
