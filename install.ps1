winget install JanDeDobbeleer.OhMyPosh -s winget
Install-Module -Name Terminal-Icons -Repository PSGallery
mkdir $env:HOMEPATH\Documents\PowerShell -Force
cp .\Microsoft.PowerShell_profile.ps1 $env:HOMEPATH\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
mkdir $env:HOMEPATH\posh_config -Force
cp .\atomic.omp.json $env:HOMEPATH\posh_config\atomic.omp.json
