local FSM = require(game.ServerScriptService.FSM)

FSM.CreateState("Happy", {
    OnEnterState = function(Entities)
        print("Entities", Entities, "entering Happy")
    end;

    OnExitState = function(Entities)
        print("Entities", Entities, "exiting Happy")
    end;
})

FSM.CreateState("Afraid", {
    OnEnterState = function(Entities)
        print("Entities", Entities, "entering Afraid")
    end;

    OnExitState = function(Entities)
        print("Entities", Entities, "exiting Afraid")
    end;
})

FSM.CreateState("Disgusted", {
    OnEnterState = function(Entities)
        print("Entities", Entities, "entering Disgusted")
    end;

    OnExitState = function(Entities)
        print("Entities", Entities, "exiting Disgusted")
    end;
})

FSM.CreateState("Angry", {
    OnEnterState = function(Entities)
        print("Entities", Entities, "entering Angry")
    end;

    OnExitState = function(Entities)
        print("Entities", Entities, "exiting Angry")
    end;
})

FSM.CreateState("Sad", {
    OnEnterState = function(Entities)
        print("Entities", Entities, "entering Sad")
    end;

    OnExitState = function(Entities)
        print("Entities", Entities, "exiting Sad")
    end;
})

FSM.CreateTransition("HappyToSad", {
    FromOr  = {"Disgusted", "Afraid", "Happy"};

    FromAnd = {"Happy", "Angry"};

    FromNot = {"Sad"};

    To      = {"Sad", "Angry"};

    OnEnterBuffer = function(Entity)
        print("Entity", Entity, "is entering Buffer HappyToSad")
    end;

    OnExitBuffer  = function(Buffer)
        print("Buffer HappyToSad", Buffer, "is clearing")
    end;
})

FSM.EnterStates({"Happy"}    , {1, 2, 3, 4})
FSM.EnterStates({"Angry"}    , {2, 3})
FSM.EnterStates({"Disgusted"}, {1, 3})
FSM.EnterStates({"Afraid"}   , {2, 4})
FSM.EnterStates({"Sad"}      , {3})

FSM.ExitStates({"Happy", "Angry"}, {1, 4})

FSM.EnterBuffer("HappyToSad", {1, 2})
FSM.EnterBuffer("HappyToSad", {3, 4})

FSM.ExitBuffer("HappyToSad")

print(FSM.DebugText())

--[[
Entities {
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [4] = 4
} entering Happy

Entities {
    [1] = 2,
    [2] = 3
} entering Angry

Entities {
    [1] = 1,
    [2] = 3
} entering Disgusted

Entities {
    [1] = 2,
    [2] = 4
} entering Afraid

Entities {
    [1] = 3
} entering Sad

Entities {
    [1] = 1,
    [2] = 4
} exiting Happy

Entity 2 is entering Buffer HappyToSad

Buffer HappyToSad {
    [1] = 2
} is clearing

Entities {
    [1] = 2
} exiting Afraid

Entities {
    [1] = 2
} exiting Happy

Entities {
    [1] = 2
} exiting Angry

Entities {
    [1] = 2
} entering Sad

Entities {
    [1] = 2
} entering Angry

FINITE STATE MACHINE DEBUG TEXT:

State Disgusted: { 1, 3 }
State Afraid: { 4 }
State Sad: { 3, 2 }
State Happy: { 3 }
State Angry: { 3, 2 }

Transition HappyToSad: {
	Buffer: {  }
	FromOr: { "Disgusted", "Afraid", "Happy" }
	FromAnd: { "Happy", "Angry" }
	FromNot: { "Sad" }
	To: { "Sad", "Angry" }
}
]]