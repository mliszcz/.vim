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
1. If not provided by the distribution, install these plugins manually:
   ```
   wget -P plugin https://raw.githubusercontent.com/junegunn/fzf/master/plugin/fzf.vim
   ```

## Updating

To update all submodules to the latest versions, run:

```bash
git submodule update --init --recursive --recommend-shallow
```
