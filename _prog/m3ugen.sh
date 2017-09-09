

#$1 == search directory
#$2 == output filename
_listTracks() {
	cd "$1"
	
	local searchDir
	
	searchDir="$1"
	
	#https://stackoverflow.com/questions/20204820/check-if-shell-script-1-is-absolute-or-relative-path
	! [[ "${searchDir:0:1}" == '/' ]] && searchDir="."
	
	find "$searchDir" -type f \( -iname '*.ogg' -o -iname '*.mp3' -o -iname '*.flac' -o -iname '*.wav' -o -iname '*.m4a' -o -iname '*.wma' -o -iname '*.wv' -o -iname '*.swa' -o -iname '*.aac' -o -iname '*.ac3' \) | sort > "$2"
	cd "$scriptAbsoluteFolder"
}


#$1 == search directory
#$2 == albumRealPath
#$3 == albumName
_writePlaylist() {
	m3uDir=$(_localDir "$1" "$2")
	m3uName="$3"-"$m3uDir"
	
	#Filter out './', '/.', and related patterns.
	m3uName="${m3uName}"
	
	m3uName="${m3uName//\.\//}"
	m3uName="${m3uName//\/\./}"
	m3uName="${m3uName//\-\./}"
	
	m3uName="${m3uName//\//-}"
	m3uName="${m3uName//\./-}"
	
	"$scriptAbsoluteLocation" _listTracks "$1" "$m3uName".m3u
}

_m3uGenerator() {
	export workDir="$PWD"
	[[ "$1" != "" ]] && export workDir="$1"
	
	export albumRealPath=$(_getAbsoluteLocation "$workDir")
	export albumName=$(basename "$albumRealPath")
	
	find "$workDir" -type d -exec "$scriptAbsoluteLocation" _writePlaylist {} "$workDir" "$albumName" \;
	
}





