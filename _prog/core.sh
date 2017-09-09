##### Core

_resetPulse() {
	pgrep kmix >/dev/null 2>&1 && resetKmix="true"
	
	pkill pulse
	pax11publish -r
	start-pulseaudio-x11
	sleep 1
	
	if [[ "$resetKmix" == "true" ]]
	then
		pkill kmix
		kmix >/dev/null 2>&1 &
	fi
}
