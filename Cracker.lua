--Types
export type Array<T> = { [number]: T }

export type TransitionName_t = any

export type Entity_t = any

export type Buffer_t = Array<Entity_t>

export type StateName_t = any

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

export type State_t = {
    Collection : { [Entity_t]: true }; --The lookup table entities are stored in

    BeforeEnterState : (Entities: Array<Entity_t>) -> nil; --The BeforeEnterState callback you optionally defined
    AfterEnterState  : (Entities: Array<Entity_t>) -> nil; --The AfterEnterState callback you optionally defined

    BeforeExitState : (Entities: Array<Entity_t>) -> nil;  --The OnExitState callback you optionally defined
    AfterExitState  : (Entities: Array<Entity_t>) -> nil;  --The OnExitState callback you optionally defined
};
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

--Reference to empty function to save memory
local NullFunction = function() end

--Internal data
local States : { [StateName_t] : State_t; } = {}
local Transitions : { [TransitionName_t] : Transition_t; } = {}

--Public api
local Module = {}

Module.CreateTransition = function(TransitionName : TransitionName_t, TransitionTemplate : TransitionTemplate_t)
	--Check if the transition already exists
	--Check if transition already exists
	assert(not Transitions[TransitionName], "Transition " .. TransitionName .. " already exists")

	--Define transition
	local Transition = {} :: Transition_t

	Transition.Buffer = {}

	Transition.FromOr  = TransitionTemplate.FromOr  or TransitionTemplate.fromOr  or TransitionTemplate.from_or  or {}
	Transition.FromAnd = TransitionTemplate.FromAnd or TransitionTemplate.fromAnd or TransitionTemplate.from_and or {}
	Transition.FromNot = TransitionTemplate.FromNot or TransitionTemplate.fromNot or TransitionTemplate.from_not or {}
	Transition.To      = TransitionTemplate.To      or TransitionTemplate.to      or                                {}

	Transition.BeforeEnterBuffer = TransitionTemplate.BeforeEnterBuffer or TransitionTemplate.beforeEnterBuffer or TransitionTemplate.before_enter_buffer or NullFunction :: (Entity_t) -> boolean?
	Transition.AfterEnterBuffer  = TransitionTemplate.AfterEnterBuffer  or TransitionTemplate.afterEnterBuffer  or TransitionTemplate.after_enter_buffer  or NullFunction :: (Entity_t) -> nil

	Transition.BeforeExitBuffer = TransitionTemplate.BeforeExitBuffer or TransitionTemplate.beforeExitBuffer or TransitionTemplate.before_exit_buffer or NullFunction :: (Buffer_t) -> boolean?
	Transition.AfterExitBuffer  = TransitionTemplate.AfterExitBuffer  or TransitionTemplate.afterExitBuffer  or TransitionTemplate.after_exit_buffer  or NullFunction :: (Buffer_t) -> nil

	--Add transition
	Transitions[TransitionName] = Transition
end

Module.DeleteTransition = function(TransitionName : TransitionName_t)
	--Get transition
	local Transition : Transition_t = Transitions[TransitionName]
	assert(Transition, "Transition " .. TransitionName .. " does not exist")

	--Remove transition
	table.clear(Transition.Buffer)
	Transitions[TransitionName] = nil
end

Module.GetTransition = function(TransitionName : TransitionName_t) : Transition_t
	--Get transition
	local Transition : Transition_t = Transitions[TransitionName]
	assert(Transition, "Transition " .. TransitionName .. " does not exist")

	return Transition
end

Module.CreateState = function(StateName : StateName_t, StateTemplate : StateTemplate_t)
	--Check if state already exists, if so warn of overwrite
	local PreviousState : State_t? = States[StateName]
	if PreviousState then warn("State ".. StateName .. " already exists, overwriting") end

	--Define state
	local State : State_t = PreviousState or {}

	State.Collection = PreviousState and PreviousState.Collection or {};

	State.BeforeEnterState = StateTemplate.BeforeEnterState or StateTemplate.beforeEnterState or StateTemplate.before_enter_state or NullFunction :: (Entities : Array<Entity_t>) -> boolean?;
	State.AfterEnterState =  StateTemplate.AfterEnterState  or StateTemplate.afterEnterState  or StateTemplate.after_enter_state  or NullFunction :: (Entities : Array<Entity_t>) -> nil;

	State.BeforeExitState = StateTemplate.BeforeExitState or StateTemplate.beforeExitState or StateTemplate.before_exit_state or NullFunction :: (Entities : Array<Entity_t>) -> boolean?;
	State.AfterExitState  = StateTemplate.AfterExitState  or StateTemplate.afterExitState  or StateTemplate.after_exit_state  or NullFunction :: (Entities : Array<Entity_t>) -> nil;

	--Add state
	States[StateName] = State

	return State
end

Module.GetState = function(StateName : StateName_t) : State_t?
	return States[StateName]
end

Module.EnterStates = function(StateNames : Array<StateName_t>, Entities : Array<Entity_t>)
	for _, StateName in ipairs(StateNames) do
		--Get state, if not found create it
		local State = Module.GetState(StateName) :: State_t
		if not State then State = Module.CreateState(StateName, {}) end

		--Filter entities if they are in the state
		local EntitiesNotInState : Array<Entity_t> = {}
		for _, Entity : Entity_t in ipairs(Entities) do
			if State.Collection[Entity] then continue end
			table.insert(EntitiesNotInState, Entity)
		end

		--Prevent adding entities to the state if all entities were filtered
		if #EntitiesNotInState == 0 then continue end

		--Call BeforeEnterState, if it returns true, don't add entities to the state
		if State.BeforeEnterState(EntitiesNotInState) then continue end

		--Add entities to the state
		for _, Entity in ipairs(EntitiesNotInState) do
			State.Collection[Entity] = true
		end

		--Call AfterEnterState
		State.AfterEnterState(EntitiesNotInState)
	end
end

Module.ExitStates = function(StateNames : Array<StateName_t>, Entities : Array<Entity_t>)
	for _, StateName in ipairs(StateNames) do
		--Get state, if not found create it
		local State = Module.GetState(StateName) :: State_t
		if not State then continue end
		
		--Filter entities if they are not in the state
		local EntitiesInState : Array<Entity_t> = {}
		for _, Entity : Entity_t in ipairs(Entities) do
			if not State.Collection[Entity] then continue end
			table.insert(EntitiesInState, Entity)
		end

		--Prevent removing entities from the state if all entities were filtered
		if #EntitiesInState == 0 then continue end

		--Call BeforeExitState, if it returns true, don't remove entities from the state
		if State.BeforeExitState(EntitiesInState) then continue end

		--Remove entities from the state
		for _, Entity in ipairs(EntitiesInState) do
			State.Collection[Entity] = nil
		end

		--Call AfterExitState
		State.AfterExitState(EntitiesInState)
	end
end

Module.ExitAllStates = function(Entities : Array<Entity_t>)
	--Get all states
	local StateNames : Array<StateName_t> = {}
	for StateName : StateName_t in pairs(States) do
		table.insert(StateNames, StateName)
	end

	--Exit all states
	Module.ExitStates(StateNames, Entities)
end

Module.IsInState = function(StateName : StateName_t, Entity : Entity_t) : boolean
	--Get state
	local State = Module.GetState(StateName) :: State_t
	if not State then return false end

	return State.Collection[Entity]
end

Module.ClearBuffer = function(TransitionName : TransitionName_t)
	--Get transition
	local Transition : Transition_t = Module.GetTransition(TransitionName)

	table.clear(Transition.Buffer)
end

Module.EnterBuffer = function(TransitionName : TransitionName_t, Entities : Array<Entity_t>)
	--Get transition
	local Transition : Transition_t = Module.GetTransition(TransitionName)

	for _, Entity : Entity_t in ipairs(Entities) do
		--Determine if entity fits the From requirements
		local ValidOr : boolean = #Transition.FromOr == 0
		local ValidAnd : boolean = true
		local ValidNot : boolean = true

		for _, SourceName : StateName_t in ipairs(Transition.FromOr) do
			if not Module.IsInState(SourceName, Entity) then continue end

			ValidOr = true
			break
		end

		for _, SourceName : StateName_t in ipairs(Transition.FromAnd) do
			if not Module.IsInState(SourceName, Entity) then continue end

			ValidAnd = false
			break
		end

		for _, SourceName : StateName_t in ipairs(Transition.FromNot) do
			if not Module.IsInState(SourceName, Entity) then continue end

			ValidNot = false
			break
		end
		
		--If not, don't add to buffer
		if not ValidOr or not ValidAnd or not ValidNot then continue end

		--Call BeforeEnterBuffer, if it returns true, don't add to buffer
		if Transition.BeforeEnterBuffer(Entity) then continue end

		--Add to buffer
		table.insert(Transition.Buffer, Entity)

		--Call AfterEnterBuffer
		Transition.AfterEnterBuffer(Entity)
	end
end

local function CommitTransition(Transition : Transition_t, Entities : Array<Entity_t>, ShouldntExitStates : boolean)
	--Transition entities to states
	if not ShouldntExitStates then
		Module.ExitStates(Transition.FromOr, Entities)
		Module.ExitStates(Transition.FromAnd, Entities)
	end

	Module.EnterStates(Transition.To, Entities)
end

Module.ExitBuffer = function(TransitionName : TransitionName_t, ShouldntExitStates : boolean)
	--Get transition
	local Transition : Transition_t = Module.GetTransition(TransitionName)

	--Call BeforeExitBuffer, if it returns true, don't remove from buffer
	if Transition.BeforeExitBuffer(Transition.Buffer) then return end

	--Transition buffer to states
	CommitTransition(Transition, Transition.Buffer, ShouldntExitStates)

	Module.ClearBuffer(TransitionName)

	--Call AfterExitBuffer
	Transition.AfterExitBuffer(Transition.Buffer)
end

Module.PassBuffer = function(TransitionName : TransitionName_t, Entities : Array<Entity_t>, ShouldntExitStates : boolean)
	--Get transition
	local Transition : Transition_t = Module.GetTransition(TransitionName)

	--Transition buffer to states
	CommitTransition(Transition, Entities, ShouldntExitStates)
end

Module.ThroughBuffer = function(TransitionName : TransitionName_t, Entities : Array<Entity_t>, ShouldntExitStates : boolean)
	Module.EnterBuffer(TransitionName, Entities)
	Module.ExitBuffer(TransitionName, ShouldntExitStates)
end

--Extras

local function TableToString(Table : table) : string
	local Result : string = "{ "
	for Key : any, Value : any in pairs(Table) do
		if typeof(Key) ~= "table" and typeof(Key) ~= "number" then
			Result ..= "[\"" .. Key .. "\"]" .. "="
		end

		if typeof(Value) == "table" then
			Result ..= TableToString(Value)

		elseif typeof(Value) == "boolean" then
			Result ..= tostring(Value)

		elseif typeof(Value) == "number" then
			Result ..= Value

		else
			Result ..= "\"" .. tostring(Value) .. "\""
		end

		Result ..= ", "
	end

	if Result ~= "" and Result ~= "{ " then
		Result = string.sub(Result, 1, -3)
	end

	return Result .. " }"
end

Module.DebugText = function() : string
	local Text : string = "FINITE STATE MACHINE DEBUG TEXT:\n\n"

	for StateName : StateName_t, State : State_t in pairs(States) do
		local DebugEntities : Array<Entity_t> = {}
		for Entity : Entity_t in pairs(State.Collection) do
			table.insert(DebugEntities, Entity)
		end

		Text ..= "State " .. StateName .. ": " .. TableToString(DebugEntities) .. "\n"
	end

	Text ..= "\n"

	for TransitionName : TransitionName_t, Transition : Transition_t in pairs(Transitions) do
		Text ..= "Transition " .. TransitionName .. ": {\n"
		Text ..= "\tBuffer: " .. TableToString(Transition.Buffer) .. "\n"
		Text ..= "\tFromOr: " .. TableToString(Transition.FromOr) .. "\n"
		Text ..= "\tFromAnd: " .. TableToString(Transition.FromAnd) .. "\n"
		Text ..= "\tFromNot: " .. TableToString(Transition.FromNot) .. "\n"
		Text ..= "\tTo: " .. TableToString(Transition.To) .. "\n"
		Text ..= "}\n"
	end

	return Text
end

return Module