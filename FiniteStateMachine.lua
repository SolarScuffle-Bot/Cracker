local States = {}
local Transitions = {}

local Module = {}

Module.CreateTransition = function(TransitionName, TransitionTemplate)
	assert(not Transitions[TransitionName], "Transition " .. TransitionName .. " already exists")

	Transitions[TransitionName] = {
		Buffer = {};

		FromOr  = TransitionTemplate.FromOr  or TransitionTemplate.fromOr  or TransitionTemplate.from_or  or {};
		FromAnd = TransitionTemplate.FromAnd or TransitionTemplate.fromAnd or TransitionTemplate.from_and or {};
		To      = TransitionTemplate.To      or TransitionTemplate.to      or                      {};

		OnEnterBuffer = TransitionTemplate.OnEnterBuffer or TransitionTemplate.onEnterBuffer or TransitionTemplate.on_enter_buffer or function(Entity) end;
		OnExitBuffer  = TransitionTemplate.OnExitBuffer  or TransitionTemplate.onExitBuffer  or TransitionTemplate.on_exit_buffer  or function(Buffer) end;
	}
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
	assert(not States[StateName], "State ".. StateName .. " already exists")

	local State = {
        Collection = {};

        OnEnterState = StateTemplate.OnEnterState or StateTemplate.onEnterState or StateTemplate.on_enter_state or function(Entities) end;
        OnExitState  = StateTemplate.OnExitState  or StateTemplate.onExitState  or StateTemplate.on_exit_state  or function(Entities) end;
    }

	States[StateName] = State

	return State
end

Module.GetState = function(StateName)
	return States[StateName]
end

Module.EnterStates = function(StateNames, Entities)
	for _, StateName in ipairs(StateNames) do
		local State = Module.GetState(StateName)
		if not State then State = Module.CreateState(StateName) end

        local EntitiesNotInState = {}
        for _, Entity in ipairs(Entities) do
            if State.Collection[Entity] then continue end
            table.insert(EntitiesNotInState, Entity)
        end

        if #EntitiesNotInState == 0 then continue end
        State.OnEnterState(EntitiesNotInState)

		for _, Entity in ipairs(EntitiesNotInState) do
			State.Collection[Entity] = true
		end
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
        State.OnExitState(EntitiesInState)

		for _, Entity in ipairs(EntitiesInState) do
			State.Collection[Entity] = nil
		end
	end
end

Module.EnterBuffer = function(TransitionName, Entities)
	local Transition = Module.GetTransition(TransitionName)

	for _, Entity in ipairs(Entities) do
		local ValidOr = #Transition.FromOr == 0
		for _, SourceName in ipairs(Transition.FromOr) do
			local SourceState = Module.GetState(SourceName)
			if not SourceState then SourceState = Module.CreateState(SourceName) end
			if not SourceState.Collection[Entity] then continue end

			ValidOr = true
			break
		end

		local ValidAnd = #Transition.FromAnd ~= 0
		for _, SourceName in ipairs(Transition.FromAnd) do
			local SourceState = Module.GetState(SourceName)
			if not SourceState then SourceState = Module.CreateState(SourceName) end
			if SourceState.Collection[Entity] then continue end

			ValidAnd = false
			break
		end

		if not ValidOr or not ValidAnd then continue end
		if Transition.OnEnterBuffer(Entity) then continue end

		table.insert(Transition.Buffer, Entity)
	end
end

Module.ExitBuffer = function(TransitionName)
	local Transition = Module.GetTransition(TransitionName)
	if Transition.OnExitBuffer(Transition.Buffer) then return end

	Module.ExitStates(Transition.FromOr, Transition.Buffer)
	Module.ExitStates(Transition.FromAnd, Transition.Buffer)
	Module.EnterStates(Transition.To, Transition.Buffer)

	table.clear(Transition.Buffer)
end

--Extras

local function TableToString(Table)
	local result = "{ "
	for k, v in pairs(Table) do
		-- Check the key type (ignore any numerical keys - assume its an array)
		if type(k) == "string" then
			result = result.."[\""..k.."\"]".."="
		end

		-- Check the value type
		if type(v) == "table" then
			result = result..TableToString(v)
		elseif type(v) == "boolean" then
			result = result..tostring(v)
		elseif type(v) == "string" then
			result = result.."\""..v.."\""
		elseif type(v) == "number" then
			result = result..v
		else
			result = result.."\""..v.."\""
		end
		result = result..", "
	end
	-- Remove leading commas from the result
	if result ~= "" then
		result = result:sub(1, result:len()-1)
	end
	return result.." }"
end

Module.DebugText = function()
	local Text = "FINITE STATE MACHINE DEBUG TEXT:\n\n"

	for _, State in pairs(States) do
		local DebugEntities = {}
		for Entity in pairs(State.Collection) do
			table.insert(DebugEntities, Entity)
		end

        Text ..= "\tCollection: " .. TableToString(DebugEntities) .. "\n"
	end

	Text ..= "\n"

	for TransitionName, Transition in pairs(Transitions) do
		Text ..= "Transition " .. TransitionName .. ": {\n"
		Text ..= "\tBuffer: " .. TableToString(Transition.Buffer) .. "\n"
		Text ..= "\tFromOr: " .. TableToString(Transition.FromOr) .. "\n"
		Text ..= "\tFromAnd: " .. TableToString(Transition.FromAnd) .. "\n"
		Text ..= "\tTo: " .. TableToString(Transition.To) .. "\n"
		Text ..= "}\n"
	end

	return Text
end

return Module