#!/bin/bash

dump_file="dotfiles/arch_install.txt"
pacman -Qe > "$HOME/$dump_file"
