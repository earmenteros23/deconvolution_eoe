#!/usr/bin/env bash

code/get_geo.bash GSE201153
code/get_geo.bash GSE175930

code/cellranger_to_seurat.R -i data/GSE201153 -t rothenberg
code/cellranger_to_seurat.R -i data/GSE175930 -t morgan

code/remove_originals.bash GSE201153
code/remove_originals.bash GSE175930