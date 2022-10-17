# Настройка Windows Terminal в Windows для полноценной работы

Гайд во многом основан на [статье от Christian Maniewski](https://chmanie.com/post/2020/07/17/modern-c-development-in-neovim/)

## [Oh My Posh](https://ohmyposh.dev/), работающий в PowerShell и WSL2

### Процесс установки
1) Для корректного отображения символов необходимо установить [Cascadia Mono Nerd](https://www.nerdfonts.com/font-downloads) или похожий (конкретно расписано в гайде по установке Oh-my-posh)
2) Добавить шрифт необходимо в `Settings->Appearence`
3) Запустить из poweshell `install_oh_my_posh.ps1`

### Установка в linux
1) Подробности есть на сайте [Oh My Posh](https://ohmyposh.dev/)
2) Добавить в конец `.profile` файла в домашней директории `eval "$(oh-my-posh --init --shell bash --config ~/.poshthemes/atomic.omp.json)"`

### Переменные среды, компиляторы и подобная хуйня

Для того, чтобы всё (компляторы/cmake/ninja) работало в винде, необходимо поставить Build Tools от Microsoft (ставятся вместе с Visual Studio)

Вместе с ним поставится `Developer Command Prompt`. Чтобы этот же функционал работал в обычном (или не совсем) powershell, в json файл для Windows Terminal'а нужно добавить

```
ваш_powershell.exe -noe -c \"&{$vsPath = &(Join-Path ${env:ProgramFiles(x86)} '\\Microsoft Visual Studio\\Installer\\vswhere.exe') -property installationpath; Import-Module (Join-Path $vsPath 'Common7\\Tools\\Microsoft.VisualStudio.DevShell.dll'); Enter-VsDevShell -VsInstallPath $vsPath -SkipAutomaticLocation}\"
```

## [Neovim](https://neovim.io/) 

Прежде всего необходимо [скачать и установить neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim)

### Plugin manager

[Vim-plug](https://github.com/junegunn/vim-plug) для установки плагинов

1) Запустить ``файл AutoloadVimPlug.ps1``
2) Отредактировать ``init.vim`` в соответствии с [гайдом](https://github.com/junegunn/vim-plug#example)
3) После захода сделать ``:PlugInstall`` или любую другую [команду](https://github.com/junegunn/vim-plug#commands)

**P.S. Плагины ставятся в nvim-data/plugged**

### LSP - Language Server Protocol

LSP'ха - это протокол комуникации между Language Server (процессом, который делает всю скучную работу типо автодополнение кода, ошибки, варнинги и всякое другое) и непосредственно редактором кода.

#### LSP Client

Хороший LSP клиент плагин для vim - это [COC](https://github.com/neoclide/coc.nvim)
Его можно установить через [Vim-plug](https://github.com/junegunn/vim-plug)
```
Plug 'neoclide/coc.nvim', {'branch': 'release'}
```

[Дальнейшая настройка](https://github.com/neoclide/coc.nvim#example-vim-configuration)

[Больше о LSP](https://learn.microsoft.com/en-us/visualstudio/extensibility/language-server-protocol?view=vs-2022)

#### LSP Server

Хороший - [CCLS](https://github.com/MaskRay/ccls/wiki/Build)
Вообще у Microsoft'а есть свой Clangd.exe, который в принципе работает, но вроде как CCLS лучше пашет (по моему впечатлению)
Вообще там есть полный гайд по установке, но на всякий случай продублирую

#### Качаем llvm
```
git clone https://github.com/llvm/llvm-project.git

cd llvm-project
cmake -Hllvm -BRelease -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=cl -DCMAKE_CXX_COMPILER=cl -DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_ENABLE_PROJECTS=clang
ninja -C Release clangFormat clangFrontendTool clangIndex clangTooling clang
```

#### Качаем ccls

```
git clone --depth=1 --recursive https://github.com/MaskRay/ccls
cd ccls

cmake -H. -BRelease -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=clang-cl -DCMAKE_CXX_COMPILER=clang-cl -DCMAKE_PREFIX_PATH="W:\BuildTools\llvm-project\Release"
ninja -C Release
```

После этого соаздётся файл `coc-settings.json`, который описывает найстройки (там же, где init.vim)

```
{
    "languageserver": {
    "ccls": {
      "command": "ccls",
      "args": ["--log-file=W:/BuildTools/ccls-tmp-files/log/ccls.log", "-v=1"],
      "filetypes": ["c", "cc", "cpp", "c++", "objc", "objcpp"],
      "rootPatterns": [".ccls", "compile_commands.json"],
      "initializationOptions": {
         "cache": {
           "directory": "W:/BuildTools/ccls-tmp-files/cache"
         },
         "client": {
          "snippetSupport": true
         }
       }
    }
  }
}
```

#### Подсветка синтаксиса

Для более продвинутой подсветки синтаксиса можно юзать LSP (способ медленнее, но точнее, чем использование стандартного vim'овского способа)

Плагин [vim-lsp-cxx-highlight](https://github.com/jackguo380/vim-lsp-cxx-highlight)

```
Plug 'jackguo380/vim-lsp-cxx-highlight'
```

Добавить в `coc-settings.json`
```
"initializationOptions": {
  // ...
  // This will re-index the file on buffer change which is definitely a performance hit. See if it works for you
  "index": {
    "onChange": true
  },
  // This is mandatory!
  "highlight": { "lsRanges" : true }
}
```

#### Цветовая тема

Поплуярная ретро цветовая схема, а также дополнительные плюшки
```
Plug 'gruvbox-community/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
```

init.vim
```
" Theme Setup
set termguicolors
colo gruvbox

" Default styling
" https://neovim.io/doc/user/options.html
" Tab stop=2 soft tab stop = 2 shift width = 2
set ts=2 sts=2 sw=2 et si ai rnu
```

#### [Форматирование](https://github.com/rhysd/vim-clang-format)

Плагин для форматирование
```
Plug 'rhysd/vim-clang-format`
```

init.vim
```
" Auto format
let g:clang_format#detect_style_file = 1
nnoremap <Leader>f :<C-u>ClangFormat<CR>
```

#### [NERD TREE](https://github.com/preservim/nerdtree)

Плагин
```
Plug 'preservim/nerdtree'
```

init.vim
```
" Nerd tree
inoremap <c-b> <Esc>:NERDTreeToggle<cr>
nnoremap <c-b> <Esc>:NERDTreeToggle<cr>
```

## Debugger

В llvm-project есть дебаггер. Собственно LLDB

```
cmake -G Ninja -DLLVM_ENABLE_PROJECTS="clang;lldb" [<cmake options>] path/to/llvm-project/llvm
ninja lldb
```

## Билд C/C++ программ
При условии, что настроен developer powershell

Для билда используется:

```
cmake -G Ninja -S sourceDir -B buildDir -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

`DCMAKE_EXPORT_COMPILE_COMMANDS` позволяет сгенерировать `compile_commands.json` файл, который будет использоваться `coc.nvim` для автодополнения и подсветки синтаксиса

Согласано [посту](https://stackoverflow.com/questions/47581784/building-a-x86-application-with-cmake-ninja-and-clang-on-x64-windows)

Ninja использует для выбора архитектуры (x64,x86) уже установленные флаги в CMakeLists.txt `set CMAKE_EXE_LINKER_FLAGS=/machine:x64`
Флаг описан у [майков](https://learn.microsoft.com/en-us/cpp/build/how-to-configure-visual-cpp-projects-to-target-64-bit-platforms?redirectedfrom=MSDN&view=msvc-160)
Или же использовать как переменные среды
```
cmake -E env CMAKE_EXE_LINKER_FLAGS=/machine:x64 cmake -G Ninja -S sourceDir -B buildDir -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Debug
```

