clearListener(); print("Cleared in:\n"+getSourceFileName())


--frameRate
--playbackSpeed
--
--timeConfiguration.playbackSpeed


playback_speed = case timeConfiguration.playbackSpeed of
(
	1: 1/4 
	2: 1/2 
	3: 1
	4: 2
	5: 4
)

format "playback_speed: %\n" playback_speed
