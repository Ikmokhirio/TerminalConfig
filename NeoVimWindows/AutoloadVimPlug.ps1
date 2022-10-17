iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim-data/site/autoload/plug.vim" -Force

New-Item -ItemType Directory -Force -Path ~/AppData/Local/nvim

New-Item ~/AppData/Local/nvim/init.vim -Force -type file

Write-Host "Your init script is in ~/AppData/Local/nvim/ folder"

Write-Host "https://github.com/junegunn/vim-plug#usage"