```lua
Transition.OnExitBuffer(Buffer: Buffer_t) -> bool?
```
Called in ExitBuffer before anything happens. If it returns a truthy value it prevents anything from happening.
<br /><br />

```lua
Cracker.CreateTransition("DetectsEnemy", {
    --From Patrolling or Guarding
    FromOr = { "Patrolling", "Guarding" };

    --But not from Dead and Sleeping and Slacking
    FromNot = { "Dead", "Sleeping", "Slacking" };

    --Going to Searching and Alerting
    To = { "Searching", "Alerting" };

    OnEnterBuffer = function(Entity)
        print(Entity, "Might have detected an enemy!")

        --Return if the guard accidentally failed to detect an enemy
        return math.random() <= Entity.DetectionFailChance
    end;

    OnExitBuffer = function(Buffer)
        print(Buffer, "Have each detected an enemy!")
    end;
})
```