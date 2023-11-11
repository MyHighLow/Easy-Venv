$EnvPath = "D:/PythonEnvironments"

function ListEnvsHelper {
	echo "Found the following environments in ${EnvPath}:"
	echo ""
	Get-ChildItem ${EnvPath} -Attributes Directory -Name
	echo ""
}

function ListPackagesHelper {
	param(
        [Parameter(Mandatory=$true, Position=0)]$EnvName
    )
	echo "Found the following packages in ${EnvPath}/${EnvName}:"
    echo ""
	Invoke-Expression "${EnvPath}/${EnvName}/Scripts/activate.ps1"
	pip freeze
    echo ""
	deactivate
}

function SetEnvHelper {
    param(
        [Parameter(Mandatory=$true, Position=0)]$EnvName
    )
	echo "Sourcing ${EnvPath}/${EnvName}"
	Invoke-Expression "${EnvPath}/${EnvName}/Scripts/activate.ps1"
}

function ShowHelpHelper {
	echo ""
    echo "ezvenv : A tool for accessing python global virtual environments, stored in your EnvPath"
    echo ""
    echo "EnvPath : $EnvPath"
    echo ""
	echo "    -ListEnvironments : List the python environments stored in $EnvPath"
    echo "    -Help : Show this help page"
    echo "    -GetPath : Show the environment path, the folder that sores your python virtual environments"
    echo "    -ListPackages <Environment Name> : list the packages installed in a virtual environment"
    echo "    -SetEnvironment <Environment Name> : Source a virtual environment stored in $$EnvPath"
    echo ""
}

function ezvenv {
    [CmdletBinding()]
    Param(
        [switch]$ListEnvironments,
        [switch]$Help,
        [switch]$GetPath,
        [string]$ListPackages
    )

    DynamicParam {
        $ParameterName="SetEnvironment"
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
            $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
                $ParameterAttribute.Position = 1
            $AttributeCollection.Add($ParameterAttribute)

        $arrSet = Get-ChildItem $EnvPath | select -ExpandProperty Name
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
        $AttributeCollection.Add($ValidateSetAttribute)

        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
        return $RuntimeParameterDictionary
    }

    begin {
        $SetEnvironment = $PsBoundParameters[$ParameterName]
        if ($ListEnvironments) {
            ListEnvsHelper
        }

        if ($Help) {
            ShowHelpHelper
        }

        if ($GetPath) {
            echo "EnvPath : %EnvPath%"
        }

        if ($ListPackages) {
            ListPackagesHelper $ListPackages
        }

        if ($SetEnvironment) {
            SetEnvHelper $SetEnvironment
        }
    }
}

Export-ModuleMember -Function ezvenv