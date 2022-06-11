# Cracker
The data-oriented finite-state-machine as described in the Data Oriented Design book implemented in Luau. https://www.dataorienteddesign.com/dodmain/node8.html

## API

### Data Types
```lua
type TransitionName_t = any;
```

```lua
type Entity_t = any;
```

```lua
type Buffer_t = { Entity_t };
```

```lua
type StateName_t = any;
```

```lua
type StateTemplate_t = {    
    OnEnterState: ({ Entity_t }) -> nil
    onEnterState: ({ Entity_t }) -> nil
    on_enter_state: ({ Entity_t }) -> nil

    OnExitState: ({ Entity_t }) -> nil
    onExitState: ({ Entity_t }) -> nil
    on_exit_state: ({ Entity_t }) -> nil
};
```

```lua
type State_t = {
    Collection: { [Entity_t]: true };
    
    OnEnterState: ({ Entity_t }) -> nil

    OnExitState: ({ Entity_t }) -> nil
};
```

```lua
type Template_t = {
    FromOr : { StateName_t }?;
    fromOr : { StateName_t }?;
    from_or: { StateName_t }?;
    
    FromAnd : { StateName_t }?;
    fromAnd : { StateName_t }?;
    from_and: { StateName_t }?;

    FromNot : { StateName_t }?;
    fromNot : { StateName_t }?;
    from_not: { StateName_t }?;
    
    To: { StateName_t }?;
    to: { StateName_t }?;
    
    OnEnterBuffer: (Entity_t)? -> bool?;
    onEnterBuffer: (Entity_t)? -> bool?;
    on_enter_buffer: (Entity_t)? -> bool?;

    OnExitBuffer: (Buffer_t)? -> bool?;
    onExitBuffer: (Buffer_t)? -> bool?;
    on_exit_buffer: (Buffer_t)? -> bool?;
}
```

```lua
type Transition_t = {
    Buffer: Buffer_t;
    
    FromOr: { StateName_t };
    
    FromAnd: { StateName_t };
    
    OnEnterBuffer: (Entity_t) -> bool?;

    OnExitBuffer: (Buffer_t) -> bool?;
}
```

### Methods
```lua
Module.CreateTransition(TransitionName: TransitionName_t, TransitionTemplate: Template_t)
```
Creates a transition with TransitionName and the properties in TransitionTemplate.

```lua
Module.DeleteTransition(TransitionName: TransitionName_t)
```
Clears the transition's buffer and deletes it.

```lua
Module.GetTransition(TransitionName: TransitionName_t) -> Transition_t
```
Gets the transition instance but errors if it doesn't exist. (Only recommended for debugging use)

```lua
Module.CreateState(StateName: StateName_t, StateTemplate: StateTemplate_t?)
```
Creates a state with StateName and the properties in StateTemplate.

```lua
Module.GetState(StateName: StateName_t) -> State_t?
```
Returns the state instance. (Only recommended for debugging use)

```lua
Module.EnterStates(StateNames: { StateName_t }, Entities: { Entity_t })
```
Adds each entity to each state in StateNames. Creates any states that do not exist.

```lua
Module.ExitStates(StateNames: { StateName_t }, Entities: { Entity_t })
```
Removes each entity from each state in StateNames. Ignores any states that do not exist.

```lua
Module.EnterBuffer(TransitionName: TransitionName_t, Entities: { Entity_t })
```
Inserts each entity if it is in the specified from-states but cancels before inserting if OnEnterBuffer(Entity) is truthy. Creates any states that do not exist.

```lua
Module.ExitBuffer(TransitionName: TransitionName_t, Entities: { Entity_t })
```
Removes all entities from the specified from-states and adds them to all to-states but cancels entirely if OnExitBuffer(Entity) is truthy. Ignores any states that do not exist when removing. Creates any states that do not exist when adding.

```lua
Module.PassBuffer(TransitionName: TransitionName_t, Entities: { Entity_t })
```
A shorthand for calling EnterBuffer and then ExitBuffer right after.

```lua
Module.DebugText() -> string
```
Returns a string of useful debugging information.

```lua
Transition.OnEnterBuffer(Entity: Entity_t) -> bool?
```
Called in EnterBuffer before each entity is inserted to the buffer. If it returns a truthy value it prevents the entity from being inserted.

```lua
Transition.OnExitBuffer(Buffer: Buffer_t) -> bool?
```
Called in ExitBuffer before anything happens. If it returns a truthy value it prevents anything from happening.

```lua
State.OnEnterState(Entities: { Entity_t })
```
Called in EnterState before all entities are added into the state. If it returns a truthy value it prevents the entities from being added.

```lua
State.OnExitState(Entities: { Entity_t })
```
Called in ExitState before all entities are removed from the state. If it returns a truthy value it prevents the entities from being removed.