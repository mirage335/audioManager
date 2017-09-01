

_audioPreprocess() {
	
	reverbType="$1"
	#Depends on http://sourceforge.net/p/sox/patches/92/ or sox > v14.4.2.

	export LADSPA_PATH=/usr/lib/ladspa

	#Guarantee stereo data early on.
	processingChain="$processingChain channels 2"

	#Necessary preprocessing, rate conversion and DC bias removal.
	#processingChain="$processingChain rate -v -I -s 44.1k ladspa -r cmt hpf 2"
	processingChain="$processingChain rate -v -I -s 48k ladspa -r cmt hpf 2"

	#Set reverberation (environment simulation) parameters.
	case "$reverbType" in
	ClearReverb)
		processingChain="$processingChain ladspa tap_reverb 1900 -2 -14 1 1 1 1 26"
		#echo -e '\E[1;32;46m'" $reverbType "'\E[0m'
		;;
	AfterBurnLongReverb)
		processingChain="$processingChain ladspa tap_reverb 4800 -4 -10 1 1 1 1 1"
		#echo -e '\E[1;32;46m'" $reverbType "'\E[0m'
		;;
	AmbienceThickHDReverb)
		processingChain="$processingChain ladspa tap_reverb 1200 -11 -14 1 1 1 1 4"
		#echo -e '\E[1;32;46m'" $reverbType "'\E[0m'
		;;
	AmbienceReverb)
		processingChain="$processingChain ladspa tap_reverb 1100 -8 -11 1 1 1 1 2"
		#echo -e '\E[1;32;46m'" $reverbType "'\E[0m'
		;;
	SmallRoomReverb)
		processingChain="$processingChain ladspa tap_reverb 1900 -6 -9 1 1 1 1 26"
		#echo -e '\E[1;32;46m'" $reverbType "'\E[0m'
		;;
	NullReverb)
		true
		#echo -e '\E[1;32;46m'" $reverbType "'\E[0m'
		;;
	*)
		echo -e '\E[1;33;41m No reverbType found, first parameter: [ClearReverb|AfterBurnLongReverb|AmbienceThickHDReverb|AmbienceReverb|SmallRoomReverb|NullReverb] \E[0m'
		exit
		;;
	esac

	#Post-reverb stereo channel mixing, as would normally occur in a real room..
	processingChain="$processingChain ladspa bs2b 650 9.5"

	#Headphone frequency correction.
	#processingChain="$processingChain ladspa -r single_para_1203 6 16000 4 ladspa -r single_para_1203 3 17000 2 ladspa -r single_para_1203 -3 250 1 ladspa -r single_para_1203 -4 1250 2 ladspa -r single_para_1203 -13 4250 0.65 ladspa -r single_para_1203 -10 7650 0.3 ladspa -r single_para_1203 -3 11250 0.65"

	#processingChain="$processingChain ladspa -r single_para_1203 4 16000 4 ladspa -r single_para_1203 3 17000 2 ladspa -r single_para_1203 -2 8500 0.2 ladspa -r single_para_1203 -1 5700 0.05 ladspa -r single_para_1203 -8 13450 0.2 ladspa -r single_para_1203 -6 8750 0.2 ladspa -r single_para_1203 1 25 2 ladspa -r single_para_1203 -5 5500 0.35"

	processingChain="$processingChain ladspa -r single_para_1203 4 16000 4 ladspa -r single_para_1203 3 17000 2 ladspa -r single_para_1203 -2 8500 0.2 ladspa -r single_para_1203 -6 5900 0.25 ladspa -r single_para_1203 -8 13450 0.2 ladspa -r single_para_1203 -6 8750 0.2 ladspa -r single_para_1203 1 25 2 ladspa -r single_para_1203 -2 5500 0.35"


	#ladspa -r single_para_1203 4 16000 4
	#ladspa -r single_para_1203 3 17000 2
	#ladspa -r single_para_1203 -2 8500 0.2
	#ladspa -r single_para_1203 -1 5700 0.05
	#ladspa -r single_para_1203 -8 13450 0.2
	#ladspa -r single_para_1203 -6 8750 0.2
	#ladspa -r single_para_1203 1 25 2
	#ladspa -r single_para_1203 -5 5500 0.35

	#Subtle effect, TubeWarmpth. Seems to slightly ease harmonic distortion. Disabled for apparently undesirable artifacts in some situations.
	processingChain="$processingChain ladspa -r tap_tubewarmth 2.5 10"

	#echo ''
	#echo -e '\E[1;32;46m'""$processingChain""'\E[0m'
	#echo ''
	
	sox --multi-threaded --buffer 131072 "$2" -C 8 "$2"-"$reverbType"-256kb.ogg $processingChain
	rm "$2"
	
	echo -e '\E[1;32;46m'""*""'\E[0m'
}

_audioPreprocessor() {
	find . -type f \( -iname '*.ogg' -o -iname '*.mp3' -o -iname '*.flac' -o -iname '*.wav' -o -iname '*.m4a' -o -iname '*.wma' -o -iname '*.wv' -o -iname '*.swa' -o -iname '*.aac' -o -iname '*.ac3' \) -print0 | xargs -0 -n 1 -P 6 "$scriptAbsoluteLocation" _audioPreprocess "$1"
}

