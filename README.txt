====================================================================
                          neovim-config
====================================================================
ABOUT
  This repository holds my configuration for NeoVim 0.12+,
  my primary editor on every system I use.

DEPENDENCIES
  - fzf, rg, fd-find, python3,
  - yazi, file(1) *, or just vifm** (https://github.com/vifm/vifm).
  - tree-sitter-cli,
  - git,
  These can all be installed through your package manager, 
  and as such I give no instructions on their installation.

INSTALL
  Simply clone the repository into your neovim config
  directory, after installing the necessary tools, and run
  neovim.

  * - An easy way to do this on Windows is to set the 
  YAZI_FILE_ONE environment variable to 
  `C:\Program Files\Git\usr\bin\file.exe` if you installed
  Git for Windows with the installer, and
  `C:\Users\<Your-Username>\scoop\apps\git\current\usr\bin\file.exe`
  if you used Scoop.
  ** - currently in implementation
