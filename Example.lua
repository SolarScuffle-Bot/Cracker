local FSM = require(game.ServerScriptService.FSM)

FSM.CreateTransition("HappyToSad", {
    FromOr = {"Disgusted", "Afraid", "Happy"};
    FromAnd = {"Happy", "Angry"};
    To = {"Sad", "Angry"};

    OnEnterBuffer = function(Entity)
        print("Entity", Entity, "is entering buffer")
    end;

    OnExitBuffer = function(Buffer)
        print("Buffer HappyToSad", Buffer, "is clearing")
    end;

    OnExitFromStates = function(Entities, FromOr, FromAnd)
        print("Entities", Entities, "are exiting states", FromOr, "and", FromAnd)
    end;

    OnEnterToStates = function(Entities, To)
        print("Entities", Entities, "are entering states ", To)
    end;
})

FSM.EnterStates({"Happy"}, {1, 2, 3, 4})
FSM.EnterStates({"Angry"}, {2, 3})
FSM.EnterStates({"Disgusted"}, {1, 3})
FSM.EnterStates({"Afraid"}, {2, 4})

FSM.ExitStates({"Happy", "Angry"}, {1, 4})

FSM.EnterBuffer("HappyToSad", {1, 2})
FSM.EnterBuffer("HappyToSad", {3, 4})

FSM.ExitBuffer("HappyToSad")

print("\n" .. FSM.DebugText())

--[[
Entity 2 is entering buffer
Entity 3 is entering buffer

Buffer HappyToSad  ▼ table: 0xa9988753c01a9292 = {
    [1] = 2,
    [2] = 3
} is clearing

Entities  ▼ table: 0xa9988753c01a9292 = {
    [1] = 2,
    [2] = 3
} are exiting states  ▼ table: 0xf5cb8ee6824ee0d2 = {
    [1] = "Disgusted",
    [2] = "Afraid",
    [3] = "Happy"
} and  ▼ table: 0x6086b553fe5a4d62 = {
    [1] = "Happy",
    [2] = "Angry"
}

Entities  ▼ table: 0xa9988753c01a9292 = {
    [1] = 2,
    [2] = 3
} are entering states   ▼ table: 0x13d1783d2f25a9f2 = {
    [1] = "Sad",
    [2] = "Angry"
}

FINITE STATE MACHINE DEBUG TEXT:

State Disgusted: { 1, }
State Afraid: { 4, }
State Sad: { 3, 2, }
State Happy: { }
State Angry: { 2, 3, }

Transition HappyToSad: {
	Buffer: { }
	FromOr: { "Disgusted", "Afraid", "Happy", }
	FromAnd: { "Happy", "Angry", }
	To: { "Sad", "Angry", }
}
]]