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
    
    FromAny : { StateName_t }?;
    fromAny : { StateName_t }?;
    from_any: { StateName_t }?;
    
    To: { StateName_t }?;
    to: { StateName_t }?;
    
    OnEnterBuffer: (Entity_t)? -> bool?;
    
    OnExitBuffer: (Buffer_t)? -> bool?;
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