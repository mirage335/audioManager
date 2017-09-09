##### Core

resetPulse() {
	pkill pulse
	pax11publish -r
	start-pulseaudio-x11
	sleep 1
	pkill kmix
	kmix >/dev/null 2>&1 &
	
}
