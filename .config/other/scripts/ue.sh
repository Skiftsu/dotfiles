ue() {
	ue4cli=$HOME/.local/bin/ue4
	engine_path=$($ue4cli root)

	if [[ "$1" == "engine" ]]; then
		cd $engine_path

	elif [[ "$1" == "rebuild" ]]; then
		$ue4cli clean
		$ue4cli build 
		if [[ "$2" == "run" ]]; then
			$ue4cli run
		fi

	elif [[ "$1" == "build" ]]; then
		if [[ "${@: -1}" == "run" ]]; then
			length="$(($# - 2))" # Get length without last param because of 'run'
			$ue4cli build ${@:2:$length}
			$ue4cli run
		else
			shift 1
			$ue4cli build "$@"
		fi

	elif [[ "$1" == "gen" ]]; then
	$ue4cli gen
	elif [[ "$1" == "gencustom" ]]; then
    $ue4cli gen
    project=${PWD##*/}
			cat ".vscode/compileCommands_${project}.json" | python -c 'import json,sys
j = json.load(sys.stdin)
for o in j:
 file = o["file"]
 arg = o["arguments"][1]
 o["arguments"] = ["clang++ -std=c++20 -ferror-limit=0 -Wall -Wextra -Wpedantic -Wshadow-all -Wno-unused-parameter " + file + " " + arg]
print(json.dumps(j, indent=2))' > compile_commands.json

  elif [[ "$1" == "lldb" ]]; then
    python -c 'import json
with open(".vscode/launch.json", "r") as file:
    j = json.load(file)
a = j["configurations"]
for o in a:
    o["type"] = "lldb"
with open(".vscode/launch.json", "w") as file:
    json.dump(j, file, indent=2)'

	else
		$ue4cli "$@"
	fi
}

