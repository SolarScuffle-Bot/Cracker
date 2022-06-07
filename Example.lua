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
    FromOr = {"Disgusted", "Afraid", "Happy"};
    FromAnd = {"Happy", "Angry"};
    To = {"Sad", "Angry"};

    OnEnterBuffer = function(Entity)
        print("Entity", Entity, "is entering buffer")
    end;

    OnExitBuffer = function(Buffer)
        print("Buffer HappyToSad", Buffer, "is clearing")
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
Entities  ▼ table: 0xf9016b1dea5ede99 = {
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [4] = 4
} entering Happy

Entities  ▼ table: 0x0f66652ac370df89 = {
    [1] = 2,
    [2] = 3
} entering Angry

Entities  ▼ table: 0xe6f632db9afd7719 = {
    [1] = 1,
    [2] = 3
} entering Disgusted

Entities  ▼ table: 0xc057c2f056678869 = {
    [1] = 2,
    [2] = 4
} entering Afraid

Entities  ▼ table: 0xa506be1527e0c839 = {
    [1] = 1,
    [2] = 4
} exiting Happy

Entity 2 is entering buffer
Entity 3 is entering buffer

Buffer HappyToSad  ▶  table: 0xf249c9715a146709  {...} is clearing
Entities  ▼ table: 0x2fb00931243e89f9 = {
    [1] = 3
} exiting Disgusted

Entities  ▼ table: 0x2d22ac384fc216e9 = {
    [1] = 2
} exiting Afraid

Entities  ▼ table: 0xb0b532a14ad79bd9 = {
    [1] = 2,
    [2] = 3
} exiting Happy

Entities  ▼ table: 0x39aa6c549e8cb9b9 = {
    [1] = 2,
    [2] = 3
} exiting Angry

Entities  ▼ table: 0xbcd3031c9b10ca29 = {
    [1] = 2,
    [2] = 3
} entering Sad

Entities  ▼ table: 0xbf409a4797a42619 = {
    [1] = 2,
    [2] = 3
} entering Angry

FINITE STATE MACHINE DEBUG TEXT:

	Collection: { 1, }
	Collection: { 4, }
	Collection: { 3, 2, }
	Collection: { }
	Collection: { 3, 2, }

Transition HappyToSad: {
	Buffer: { }
	FromOr: { "Disgusted", "Afraid", "Happy", }
	FromAnd: { "Happy", "Angry", }
	To: { "Sad", "Angry", }
}

]]