winget install JanDeDobbeleer.OhMyPosh -s winget
Install-Module -Name Terminal-Icons -Repository PSGallery
cp .\Microsoft.PowerShell_profile.ps1 $env:HOMEPATH\Documents\PowerShell\Microsoft.PowerShell_profile.ps1i
mkdir $env:HOMEPATH\posh_config
cp .\atomic.omp.json $env:HOMEPATH\posh_config\atomic.omp.json
