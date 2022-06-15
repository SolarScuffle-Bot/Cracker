local NullFunction = function() end

local States = {}
local Transitions = {}

local Module = {}

Module.CreateTransition = function(TransitionName, TransitionTemplate)
	assert(not Transitions[TransitionName], "Transition " .. TransitionName .. " already exists")

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

	Transitions[TransitionName] = Transition
end

Module.DeleteTransition = function(TransitionName)
	local Transition = Transitions[TransitionName]
	assert(Transition, "Transition " .. TransitionName .. " does not exist")

	table.clear(Transition.Buffer)
	Transitions[TransitionName] = nil
end

Module.GetTransition = function(TransitionName)
	local Transition = Transitions[TransitionName]
	assert(Transition, "Transition " .. TransitionName .. " does not exist")

	return Transition
end

Module.CreateState = function(StateName, StateTemplate)
	local PreviousState = States[StateName]
	if PreviousState then warn("State ".. StateName .. " already exists, overwriting") end

	local State = PreviousState or {}

	State.Collection = PreviousState and PreviousState.Collection or {};

	State.BeforeEnterState = StateTemplate.BeforeEnterState or StateTemplate.beforeEnterState or StateTemplate.before_enter_state or NullFunction;
	State.AfterEnterState =  StateTemplate.AfterEnterState  or StateTemplate.afterEnterState  or StateTemplate.after_enter_state  or NullFunction;

	State.BeforeExitState = StateTemplate.BeforeExitState or StateTemplate.beforeExitState or StateTemplate.before_exit_state or NullFunction;
	State.AfterExitState  = StateTemplate.AfterExitState  or StateTemplate.afterExitState  or StateTemplate.after_exit_state  or NullFunction;

	States[StateName] = State

	return State
end

Module.GetState = function(StateName)
	return States[StateName]
end

Module.EnterStates = function(StateNames, Entities)
	for _, StateName in ipairs(StateNames) do
		local State = Module.GetState(StateName)
		if not State then State = Module.CreateState(StateName, {}) end

		local EntitiesNotInState = {}
		for _, Entity in ipairs(Entities) do
			if State.Collection[Entity] then continue end
			table.insert(EntitiesNotInState, Entity)
		end

		if #EntitiesNotInState == 0 then continue end
		if State.BeforeEnterState(EntitiesNotInState) then continue end

		for _, Entity in ipairs(EntitiesNotInState) do
			State.Collection[Entity] = true
		end

		State.AfterEnterState(EntitiesNotInState)
	end
end

Module.ExitStates = function(StateNames, Entities)
	for _, StateName in ipairs(StateNames) do
		local State = Module.GetState(StateName)
		if not State then continue end
		
		local EntitiesInState = {}
		for _, Entity in ipairs(Entities) do
			if not State.Collection[Entity] then continue end
			table.insert(EntitiesInState, Entity)
		end

		if #EntitiesInState == 0 then continue end
		if State.BeforeExitState(EntitiesInState) then continue end

		for _, Entity in ipairs(EntitiesInState) do
			State.Collection[Entity] = nil
		end

		State.AfterExitState(EntitiesInState)
	end
end

Module.ExitAllStates = function(Entities)
	local StateNames = {}
	for StateName in pairs(States) do
		table.insert(StateNames, StateName)
	end

	Module.ExitStates(StateNames, Entities)
end

Module.IsInState = function(StateName, Entity)
	local State = Module.GetState(StateName)
	if not State then return false end

	return State.Collection[Entity]
end

Module.EnterBuffer = function(TransitionName, Entities)
	local Transition = Module.GetTransition(TransitionName)
	
	for _, Entity in ipairs(Entities) do
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
		
		if not ValidOr or not ValidAnd or not ValidNot then continue end
		if Transition.BeforeEnterBuffer(Entity) then continue end

		table.insert(Transition.Buffer, Entity)

		Transition.AfterEnterBuffer(Entity)
	end
end

Module.ExitBuffer = function(TransitionName)
	local Transition = Module.GetTransition(TransitionName)
	if Transition.BeforeExitBuffer(Transition.Buffer) then return end

	Module.ExitStates(Transition.FromOr, Transition.Buffer)
	Module.ExitStates(Transition.FromAnd, Transition.Buffer)
	Module.EnterStates(Transition.To, Transition.Buffer)

	table.clear(Transition.Buffer)

	Transition.AfterExitBuffer(Transition.Buffer)
end

Module.PassBuffer = function(TransitionName, Entities)
	local Transition = Module.GetTransition(TransitionName)

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