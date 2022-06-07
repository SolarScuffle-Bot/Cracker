# FiniteStateMachine
This is a data-oriented finite state machine as described in the Data Oriented Design book implemented in Luau. https://www.dataorienteddesign.com/dodbook/

## API

### Data Types
```lua
type TransitionName_t: any;
```

```lua
type Entity_t: any;
```

```lua
type Buffer_t: { Entity_t };
```

```lua
type StateName_t: any;
```

```lua
type State_t: { [Entity_t]: true };
```

```lua
type Template_t = {
    FromOr : { StateName_t }?;
    fromOr : { StateName_t }?;
    from_or: { StateName_t }?;
    
    FromAnd : { StateName_t }?;
    fromAnd : { StateName_t }?;
    from_and: { StateName_t }?;
    
    To: { StateName_t }?;
    to: { StateName_t }?;
    
    OnEnterBuffer: (Entity_t)? -> bool?;
    onEnterBuffer: (Entity_t)? -> bool?;
    on_enter_buffer: (Entity_t)? -> bool?;

    OnExitBuffer: (Buffer_t)? -> bool?;
    onExitBuffer: (Buffer_t)? -> bool?;
    on_exit_buffer: (Buffer_t)? -> bool?;

    OnExitFromStates: (Buffer_t, { StateName_t }, { StateName_t })? -> nil
    onExitFromStates: (Buffer_t, { StateName_t }, { StateName_t })? -> nil
    on_exit_from_states: (Buffer_t, { StateName_t }, { StateName_t })? -> nil

    OnEnterToStates: (Buffer_t, { StateName_t })? -> nil
    onEnterToStates: (Buffer_t, { StateName_t })? -> nil
    on_enter_to_states: (Buffer_t, { StateName_t })? -> nil
}
```

```lua
type Transition = {
    Buffer: Buffer_t;
    
    FromOr: { StateName_t };
    
    FromAnd: { StateName_t };
    
    OnEnterBuffer: (Entity_t) -> bool?;

    OnExitBuffer: (Buffer_t) -> bool?;

    OnExitFromStates: (Buffer_t, { StateName_t }, { StateName_t }) -> nil;

    OnEnterToStates: (Buffer_t, { StateName_t }) -> nil;
}
```

### Methods
```lua
.CreateTransition(TransitionName: TransitionName_t, Template: Template_t)
```
Internally creates a Transition struct using the Template at TransitionName. Creates any States that do not exist at the time of calling.

```lua
.DeleteTransition(TransitionName: TransitionName_t)
```
Clears the Transition struct's buffer and internally deletes the Transition struct with TransitionName.

```lua
.GetTransition(TransitionName: TransitionName_t) -> Transition_t?
```
Asserts the Transition struct at TransitionName exists, then returns it. (Only recommended for debugging use)

```lua
.CreateState(StateName: StateName_t, Entities: { Entity_t }?)
```
Internally creates a State table at StateName with Entities or {}.

```lua
.GetState(StateName: StateName_t) -> State_t?
```
Returns the State table at StateName if it exists. (Only recommended for debugging use)

```lua
.EnterStates(StateNames: { StateName_t }, Entities: { Entity_t })
```
Sets each Entity to true in States at names listed in StateNames. Creates any States that do not exist at the time of calling.

```lua
.ExitStates(StateNames: { StateName_t }, Entities: { Entity_t })
```
Sets each Entity to nil in States at names listed in StateNames. Ignores non-existant States.

```lua
.EnterBuffer(TransitionName: TransitionName_t, Entities: { Entity_t })
```
Inserts each Entity into the Transition at TransitionName's buffer if it is in all required States. Cancels before inserting if Transition.OnEnterBuffer(Entity) is truthy. Creates any States that do not exist at the time of calling.

```lua
.ExitBuffer(TransitionName: TransitionName_t, Entities: { Entity_t })
```
Sets all Entities to nil in each From State and to true in each To State in the Transition at TransitionName. Cancels before bulk insertion if Transition.OnExitBuffer(Transition.Buffer) is truthy. Creates any States that do not exist at the time of calling. Ignores non-existant States.

```lua
.DebugText() -> string
```
Returns a string of most useful debugging information.

```lua
.OnEnterBuffer(Entity: Entity_t) -> bool?
```
Called before Entity is inserted into the buffer. If it returns a truthy value the Entity will not be inserted.

```lua
.OnExitBuffer(Buffer: Buffer_t) -> bool?
```
Called before all Entities in Buffer are removed from their From States and added to their To States. If it returns a truthy value the buffer will not be cleared.

```lua
.OnExitFromStates(Buffer: Buffer_t, FromOr: { StateName_t }, FromAnd: { StateName_t })
```
Called right before Entities in Buffer are removed from the From States.

```lua
.OnEnterToStates(Buffer: Buffer_t, FromOr: { StateName_t }, FromAnd: { StateName_t })
```
Called right before Entities in Buffer are added to the To States.