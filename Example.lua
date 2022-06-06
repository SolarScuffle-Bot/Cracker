local FSM = require(game.ServerScriptService.FSM)

FSM.CreateTransition("HappyToSad", {
    FromOr = {"Disgusted", "Afraid", "Happy"};
    FromAnd = {"Happy", "Angry"};
    To = {"Sad", "Angry"};

    OnEnterBuffer = function(Entity)
        print("Entity " .. Entity .. " is in states (Disgusted or Afraid or Happy) and (Happy and Angry), entering buffer")
    end;

    OnExitBuffer = function(Buffer)
        print("Buffer HappyToSad { " .. table.concat(Buffer, ', ') .. " } is exiting buffer and entering (Sad and Angry)")
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
Entity 2 is in states (Disgusted or Afraid or Happy) and (Happy and Angry), entering buffer
Entity 3 is in states (Disgusted or Afraid or Happy) and (Happy and Angry), entering buffer
Buffer HappyToSad { 2, 3 } is exiting buffer and entering (Sad and Angry)

FINITE STATE MACHINE DEBUG TEXT:

State Disgusted: { 1 }
State Afraid: { 4 }
State Sad: { 2, 3 }
State Happy: {  }
State Angry: { 2, 3 }

Transition HappyToSad: {
    Buffer: {  }
    OrSourceNames: { Disgusted, Afraid, Happy }
    AndSourceNames: { Happy, Angry }
    TargetNames: { Sad, Angry }
}
]]