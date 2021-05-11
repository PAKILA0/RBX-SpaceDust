# RBX-SpaceDust
Spacedust help achieve sense of speed in games with huge open space that lack of reference points

## Using SpaceDust

```lua
-- Load module:
local Spacedust = require(LocationOfModule)

-- Step up:
Spacedust:SetupSpacedust(Character)

-- Since this is visual effect, the update is hook onto the heartBeat event, leaving Renderstep to more important stuffs.
-- Start Update:
Spacedust:Start()

-- Stop Update:
Spacedust:Stop()
```
