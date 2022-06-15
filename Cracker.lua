--Reference to empty function to save memory
local NullFunction = function() end

--Internal data
local States = {}
local Transitions = {}

--Public api
local Module = {}

Module.CreateTransition = function(TransitionName, TransitionTemplate)
	--Check if transition already exists
	assert(not Transitions[TransitionName], "Transition " .. TransitionName .. " already exists")

	--Define transition
	local Transition = {}

	Transition.Buffer = {}

	Transition.FromOr  = TransitionTemplate.FromOr  or TransitionTemplate.fromOr  or TransitionTemplate.from_or  or {}
	Transition.FromAnd = TransitionTemplate.FromAnd or TransitionTemplate.fromAnd or TransitionTemplate.from_and or {}
	Transition.FromNot = TransitionTemplate.FromNot or TransitionTemplate.fromNot or TransitionTemplate.from_not or {}
	Transition.To      = TransitionTemplate.To      or TransitionTemplate.to      or                                {}

	Transition.BeforeEnterBuffer = TransitionTemplate.BeforeEnterBuffer or TransitionTemplate.beforeEnterBuffer or TransitionTemplate.before_enter_buffer or NullFunction
	Transition.AfterEnterBuffer  = TransitionTemplate.AfterEnterBuffer  or TransitionTemplate.afterEnterBuffer  or TransitionTemplate.after_enter_buffer  or NullFunction

	Transition.BeforeExitBuffer = TransitionTemplate.BeforeExitBuffer or TransitionTemplate.beforeExitBuffer or TransitionTemplate.before_exit_buffer or NullFunction
	Transition.AfterExitBuffer  = TransitionTemplate.AfterExitBuffer  or TransitionTemplate.afterExitBuffer  or TransitionTemplate.after_exit_buffer  or NullFunction

	--Add transition
	Transitions[TransitionName] = Transition
end

Module.DeleteTransition = function(TransitionName)
	--Get transition
	local Transition = Transitions[TransitionName]
	assert(Transition, "Transition " .. TransitionName .. " does not exist")

	--Remove transition
	table.clear(Transition.Buffer)
	Transitions[TransitionName] = nil
end

Module.GetTransition = function(TransitionName)
	--Get transition
	local Transition = Transitions[TransitionName]
	assert(Transition, "Transition " .. TransitionName .. " does not exist")

	return Transition
end

Module.CreateState = function(StateName, StateTemplate)
	--Check if state already exists, if so warn of overwrite
	local PreviousState = States[StateName]
	if PreviousState then warn("State ".. StateName .. " already exists, overwriting") end

	--Define state
	local State = PreviousState or {}

	State.Collection = PreviousState and PreviousState.Collection or {};

	State.BeforeEnterState = StateTemplate.BeforeEnterState or StateTemplate.beforeEnterState or StateTemplate.before_enter_state or NullFunction;
	State.AfterEnterState =  StateTemplate.AfterEnterState  or StateTemplate.afterEnterState  or StateTemplate.after_enter_state  or NullFunction;

	State.BeforeExitState = StateTemplate.BeforeExitState or StateTemplate.beforeExitState or StateTemplate.before_exit_state or NullFunction;
	State.AfterExitState  = StateTemplate.AfterExitState  or StateTemplate.afterExitState  or StateTemplate.after_exit_state  or NullFunction;

	--Add state
	States[StateName] = State

	return State
end

Module.GetState = function(StateName)
	return States[StateName]
end

Module.EnterStates = function(StateNames, Entities)
	for _, StateName in ipairs(StateNames) do
		--Get state, if not found create it
		local State = Module.GetState(StateName)
		if not State then State = Module.CreateState(StateName, {}) end

		--Filter entities if they are in the state
		local EntitiesNotInState = {}
		for _, Entity in ipairs(Entities) do
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

Module.ExitStates = function(StateNames, Entities)
	for _, StateName in ipairs(StateNames) do
		--Get state, if not found create it
		local State = Module.GetState(StateName)
		if not State then continue end
		
		--Filter entities if they are not in the state
		local EntitiesInState = {}
		for _, Entity in ipairs(Entities) do
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

Module.ExitAllStates = function(Entities)
	--Get all states
	local StateNames = {}
	for StateName in pairs(States) do
		table.insert(StateNames, StateName)
	end

	--Exit all states
	Module.ExitStates(StateNames, Entities)
end

Module.IsInState = function(StateName, Entity)
	--Get state
	local State = Module.GetState(StateName)
	if not State then return false end

	return State.Collection[Entity]
end

Module.EnterBuffer = function(TransitionName, Entities)
	--Get transition
	local Transition = Module.GetTransition(TransitionName)

	for _, Entity in ipairs(Entities) do
		--Determine if entity fits the From requirements
		local ValidOr = #Transition.FromOr == 0
		for _, SourceName in ipairs(Transition.FromOr) do
			local SourceState = Module.GetState(SourceName)
			if not SourceState then SourceState = Module.CreateState(SourceName, {}) end
			if not SourceState.Collection[Entity] then continue end

			ValidOr = true
			break
		end

		local ValidAnd = true
		for _, SourceName in ipairs(Transition.FromAnd) do
			local SourceState = Module.GetState(SourceName)
			if not SourceState then SourceState = Module.CreateState(SourceName, {}) end
			if SourceState.Collection[Entity] then continue end

			ValidAnd = false
			break
		end

		local ValidNot = true
		for _, SourceName in ipairs(Transition.FromNot) do
			local SourceState = Module.GetState(SourceName)
			if not SourceState then SourceState = Module.CreateState(SourceName, {}) end
			if not SourceState.Collection[Entity] then continue end

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

Module.ExitBuffer = function(TransitionName)
	--Get transition
	local Transition = Module.GetTransition(TransitionName)

	--Call BeforeExitBuffer, if it returns true, don't remove from buffer
	if Transition.BeforeExitBuffer(Transition.Buffer) then return end

	--Transition buffer to states
	Module.ExitStates(Transition.FromOr, Transition.Buffer)
	Module.ExitStates(Transition.FromAnd, Transition.Buffer)
	Module.EnterStates(Transition.To, Transition.Buffer)

	table.clear(Transition.Buffer)

	--Call AfterExitBuffer
	Transition.AfterExitBuffer(Transition.Buffer)
end

Module.PassBuffer = function(TransitionName, Entities)
	--Get transition
	local Transition = Module.GetTransition(TransitionName)

	--Transition buffer to states
	Module.ExitStates(Transition.FromOr, Entities)
	Module.ExitStates(Transition.FromAnd, Entities)
	Module.EnterStates(Transition.To, Entities)
end

Module.ThroughBuffer = function(TransitionName, Entities)
	Module.EnterBuffer(TransitionName, Entities)
	Module.ExitBuffer(TransitionName)
end

--Extras

local function TableToString(Table)
	local Result = "{ "
	for Key, Value in pairs(Table) do
		if type(Key) ~= "table" and type(Key) ~= "number" then
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

Module.DebugText = function()
	local Text = "FINITE STATE MACHINE DEBUG TEXT:\n\n"

	for StateName, State in pairs(States) do
		local DebugEntities = {}
		for Entity in pairs(State.Collection) do
			table.insert(DebugEntities, Entity)
		end

		Text = Text .. "State " .. StateName .. ": " .. TableToString(DebugEntities) .. "\n"
	end

	Text ..= "\n"

	for TransitionName, Transition in pairs(Transitions) do
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