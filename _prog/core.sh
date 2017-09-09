##### Core

_resetPulse() {
	pgrep kmix >/dev/null 2>&1 && resetKmix="true"
	
	pkill pulse >/dev/null 2>&1
	pgrep pulse >/dev/null 2>&1 && sleep 1
	pkill -KILL >/dev/null 2>&1 pulse
	pgrep pulse >/dev/null 2>&1 && sleep 1
	
	pax11publish -r
	start-pulseaudio-x11
	sleep 5
	
	if [[ "$resetKmix" == "true" ]]
	then
		pkill kmix
		kmix >/dev/null 2>&1 &
	fi
}
