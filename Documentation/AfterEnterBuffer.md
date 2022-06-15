```lua
Transition.AfterEnterBuffer(Entity: Entity_t) -> bool?
```
Called in EnterBuffer after each entity is inserted to the buffer.
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

    AfterEnterBuffer = function(Entity)
        print(Entity, "Has detected an enemy!")
    end;
})
```