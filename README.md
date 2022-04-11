# .vim

Configuration for Vim and Neovim.

## Installation

1. Clone the repository into `~/.vim` for use with Vim
1. Change directory to the just cloned repository
1. Make a symlink for use with Neovim:
   ```
   ln -s $PWD ~/.config/nvim
   ```
1. Pull the plugins:
   ```
   git submodule update --init --recursive --recommend-shallow
   ```
