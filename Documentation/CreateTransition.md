```lua
Module.CreateTransition(TransitionName: TransitionName_t, TransitionTemplate: Template_t)
```
Creates a transition with TransitionName and the properties in TransitionTemplate.
<br /><br />

```lua
Cracker.CreateTransition("DetectsEnemy", {
    --From Patrolling or Guarding
    FromOr = { "Patrolling", "Guarding" };

    --But not from Dead and Sleeping and Slacking
    FromNot = { "Dead", "Sleeping", "Slacking" };

    --Going to Searching and Alerting
    To = { "Searching", "Alerting" };

    BeforeEnterBuffer = function(Entity)
        print(Entity, "Might have detected an enemy!")

        --Return if the guard accidentally failed to detect an enemy
        return math.random() <= Entity.DetectionFailChance
    end;

    AfterExitBuffer = function(Buffer)
        print(Buffer, "Have all detected enemies!")
    end;
})

Cracker.CreateTransition("Dies", {
    --The Dead cannot die
    FromNot = { "Dead" };

    --To the dust they will return
    To = { "Dead" };
})

--After 10 seconds everyone hears something in the distance
task.wait(10)
Cracker.PassBuffer("DetectsEnemy", Entities)
```