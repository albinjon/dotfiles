#!/bin/bash

dump_file="dotfiles/arch_install.txt"
pacman -Qet > "$HOME/$dump_file"
