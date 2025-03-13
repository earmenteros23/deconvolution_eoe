#!/usr/bin/env bash

tree  data/GSE175930_organized_morgan/  | sed 's/\x1B\[[0-9;]*m//g'  > visuals/renamed_dirs_tree.txt
tree data/GSE201153_organized_rothenberg/  | sed 's/\x1B\[[0-9;]*m//g'   >> visuals/renamed_dirs_tree.txt

echo "Captura guardada en visuals/renamed_dirs_tree.txt"
