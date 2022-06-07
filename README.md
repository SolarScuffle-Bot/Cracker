# FiniteStateMachine
A data-oriented finite-state-machine as described in the Data Oriented Design book implemented in Luau. https://www.dataorienteddesign.com/dodbook/

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
type Transition = {
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
Internally creates a Transition struct using the TransitionTemplate at TransitionName. Creates any States that do not exist at the time of calling.

```lua
Module.DeleteTransition(TransitionName: TransitionName_t)
```
Clears the Transition struct's buffer and internally deletes the Transition struct with TransitionName.

```lua
Module.GetTransition(TransitionName: TransitionName_t) -> Transition_t?
```
Asserts the Transition struct at TransitionName exists, then returns it. (Only recommended for debugging use)

```lua
Module.CreateState(StateName: StateName_t, StateTemplate: StateTemplate_t?)
```
Internally creates a State table at StateName with StateTemplate at StateName.

```lua
Module.GetState(StateName: StateName_t) -> State_t?
```
Returns the State table at StateName if it exists. (Only recommended for debugging use)

```lua
Module.EnterStates(StateNames: { StateName_t }, Entities: { Entity_t })
```
Sets each Entity to true in States at names listed in StateNames. Creates any States that do not exist at the time of calling.

```lua
Module.ExitStates(StateNames: { StateName_t }, Entities: { Entity_t })
```
Sets each Entity to nil in States at names listed in StateNames. Ignores non-existant States.

```lua
Module.EnterBuffer(TransitionName: TransitionName_t, Entities: { Entity_t })
```
Inserts each Entity into the Transition at TransitionName's buffer if it is in all required States. Cancels before inserting if Transition.OnEnterBuffer(Entity) is truthy. Creates any States that do not exist at the time of calling.

```lua
Module.ExitBuffer(TransitionName: TransitionName_t, Entities: { Entity_t })
```
Sets all Entities to nil in each From State and to true in each To State in the Transition at TransitionName. Cancels before bulk insertion if Transition.OnExitBuffer(Transition.Buffer) is truthy. Creates any States that do not exist at the time of calling. Ignores non-existant States.

```lua
Module.DebugText() -> string
```
Returns a string of most useful debugging information.

```lua
Transition.OnEnterBuffer(Entity: Entity_t) -> bool?
```
Called before Entity is inserted into the buffer. If it returns a truthy value the Entity will not be inserted.

```lua
Transition.OnExitBuffer(Buffer: Buffer_t) -> bool?
```
Called before all Entities in Buffer are removed from their From States and added to their To States. If it returns a truthy value the buffer will not be cleared.

```lua
State.OnEnterState(Entities: { Entity_t })
```
Called before all Entities are added to the State. Entities are filtered so only Entities that will be added are passed in.

```lua
State.OnExitState(Entities: { Entity_t })
```
Called before all Entities are removed from the State. Entities are filtered so only Entities that will be removed are passed in.