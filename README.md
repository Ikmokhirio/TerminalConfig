# Настройка Windows Terminal

## Основная цель - получить рабочий Windows Terminal с [Oh My Posh](https://ohmyposh.dev/), работающий в PowerShell и WSL2

### Процесс установки
1) Для корректного отображения символов необходимо установить [Cascadia Mono Nerd](https://www.nerdfonts.com/font-downloads) или похожий (конкретно расписано в гайде по установке Oh-my-posh)
2) Добавить шрифт необходимо в `Settings->Appearence`
3) Запустить из poweshell `install.ps1`

### Установка в linux
1) Подробности есть на сайте [Oh My Posh](https://ohmyposh.dev/)
2) Добавить в конец `.profile` файла в домашней директории `eval "$(oh-my-posh --init --shell bash --config ~/.poshthemes/atomic.omp.json)"`

### Билд C/C++ программ
Билд с использованием [CMake](https://cmake.org/install/).
1) Необходимо его установить
2) Установить компилятор, например [MSVC](https://visualstudio.microsoft.com/ru/downloads/)
3) Для сборки проекта:
  - `cmake -S ./sourceFolder -B ./buildDirectoryX64 -A x64` или `cmake -S ./sourceFolder -B ./buildDirectoryX86 -A win32`
    и после этого
  - `cmake --build ./buildDirectoryX64 --config Debug` или `cmake --build ./buildDirectoryX64 --config Release`
