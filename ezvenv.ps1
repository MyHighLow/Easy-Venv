$EnvPath = "D:/PythonEnvironments"




function ListEnvs {
	echo "Found the following environments in ${EnvPath}:"
	echo ""
	Get-ChildItem ${EnvPath} -Attributes Directory -Name
	echo ""
}

function ListPackages {
	$EnvName = $args[0]
	echo "Found the following packages in ${EnvPath}/${EnvName}:"
	Invoke-Expression "${EnvPath}/${EnvName}/Scripts/activate.ps1"
	pip freeze
	deactivate
}

function SetEnv {
	$EnvName = $args[0]
	echo "Sourcing ${EnvPath}/${EnvName}"
	Invoke-Expression "${EnvPath}/${EnvName}/Scripts/activate.ps1"
}

function ShowHelp {
	echo "EnvPath : %EnvPath%"
	echo "Usage:"
	echo "	ezenv environment"
	echo "	ezenv [options] [environment]"
	echo "Options:"
	echo "   -h                              Displays help page"
	echo "   help"
	echo ""
	echo "   -le                             Lists environments in the Environment Path"
	echo "   --list-envs"
	echo "   --list-environments"
	echo ""
	echo "   -lp ENVIRONMENT                 Lists packages in environment"
	echo "   --list-packages ENVIRONMENT"
}

if ("-le", "--list-envs", "--list-environments" -contains $args[0]) {
	ListEnvs
}
elseif ("-lp", "--list-packages" -contains $args[0]) {
	ListPackages $args[1]
}
elseif ("-h", "--help" -contains $args[0]) {
	ShowHelp
}
else {
	SetEnv $args[0]
}


