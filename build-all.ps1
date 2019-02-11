param(    
    [string] $os='windowsservercore',
    [string] $osBranch='ltsc2019',
    [bool] $ignoreTestFailures=$false,
    [object[]] $dockerConfig
)

$osAndBranch="$os\$osBranch\"
$startPath=$(pwd)

$dockerfiles = Get-ChildItem -Filter Dockerfile -recurse | where {
$_.FullName.Contains($osAndBranch) }

Write-Host "* Building $($dockerfiles.Length) Dockerfiles for $osAndBranch"

try {
    $dockerfiles | foreach {
        Write-Host "** Building $($_.FullName)"
        $path = $_.DirectoryName
        cd $path
        ..\..\..\build-tag-push.ps1 -ignoreTestFailures $ignoreTestFailures
    }
}
finally {
    cd $startPath
}