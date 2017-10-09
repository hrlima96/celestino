local scenarioLoader = {}
local backgroundLoader = require( "core.loaders.background" )
local doorLoader = require( "core.loaders.door" )
local trapDoorLoader = require( "core.loaders.trapdoor" )

scenarioLoader.loadBackground = backgroundLoader.loadBackground
scenarioLoader.loadClosedDoor = doorLoader.loadClosedDoor
scenarioLoader.loadTrapDoor = trapDoorLoader.loadTrapDoor

return scenarioLoader