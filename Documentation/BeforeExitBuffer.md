```lua
Transition.BeforeExitBuffer(Buffer: Buffer_t) -> bool?
```
Called in ExitBuffer before anything happens. If it returns a truthy value it prevents anything from happening.
<br /><br />

```lua
local ArmoryWasSabatoged = 0.7

Cracker.CreateTransition("DetectsEnemy", {
    --From Patrolling or Guarding
    FromOr = { "Patrolling", "Guarding" };

    --But not from Dead and Sleeping and Slacking
    FromNot = { "Dead", "Sleeping", "Slacking" };

    --Going to Searching and Alerting
    To = { "Searching", "Alerting" };

    BeforeExitBuffer = function(Buffer)
        print(Buffer, "Have all seen an enemy, getting weapons")

        return math.random() <= ArmoryWasSabatoged
    end;

    AfterExitBuffer = function(Buffer)
        print(Buffer, "Have all gathered their weapons, entering search for intruder")
    end;
})
```