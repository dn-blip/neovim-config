==========================================================
                      neovim-config
==========================================================
ABOUT
  This repository holds my configuration for NeoVim 0.12+,
  my primary editor on every system I use.

DEPENDENCIES
  - fzf, rg, fd-find, python3,
  - yazi, file(1),
  - tree-sitter-cli,
  - git,
  These can all be installed through your package manager, 
  and as such I give no instructions on their installation.

INSTALL
  Run mkdir ~/.config/nvim if ~/.config doesn't exist.
  On Windows, replace ~/.config/nvim/ with 
  %USERPROFILE%\AppData\Local\nvim\
  
  $ cd ~/.config/nvim/
  $ git clone https://github.com/dn-blip/neovim-config
  $ cp -r neovim-config/ nvim/
  $ rm -rf neovim-config
