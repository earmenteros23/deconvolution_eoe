rule modified_files:
    input:
        "data/GSE201153.tar",
        "data/GSE201153/",
        "data/GSE175930.tar",
        "data/GSE175930/",
        "data/.GSE201153_removed",
        "data/.GSE201153.tar_removed",
        "data/.GSE175930_removed",
        "data/.GSE175930.tar_removed",
        "data/.runs_renamed_completed"

rule final_files:
    input:
        "data/GSE201153_organized_rothenberg/",
        "data/GSE175930_organized_morgan/"



rule get_geo_GSE201153:
    input:
        script= "code/get_geo.bash"
    output:
        tar = "data/GSE201153.tar",
        untar= directory("data/GSE201153/")
    params:
        geo = "GSE201153"
    shell:
      """
      {input.script} {params.geo}
      """

rule get_geo_GSE175930:
    input:
        script= "code/get_geo.bash"
    output:
        tar = "data/GSE175930.tar",
        untar= directory("data/GSE175930/")
    params:
        geo = "GSE175930"
    shell:
      """
      {input.script} {params.geo}
      """

rule seurat_readable_rothenberg:
    input:
        script="code/seurat_readable.R",
        rothenberg_dir=directory("data/GSE201153/")
    output:
        directory("data/GSE201153_organized_rothenberg/")
    params:
        in_dir = "data/GSE201153",
        tag = "rothenberg"
    shell:
        """
        Rscript {input.script} -i {params.in_dir} -t {params.tag} 
        """

rule seurat_readable_morgan:
    input:
        script="code/seurat_readable.R",
        morgan_dir = directory("data/GSE175930/")
    output:
        directory("data/GSE175930_organized_morgan/")
    params:
        in_dir = "data/GSE175930",
        tag = "morgan"
    shell:
        """
        Rscript {input.script} -i {params.in_dir} -t {params.tag} 
        """

rule remove_GSE201153:
    input:
        script= "code/remove_originals.bash",
        direct=directory("data/GSE201153_organized_rothenberg/")
    output:
        untar="data/.GSE201153_removed",
        tar="data/.GSE201153.tar_removed"
    params:
        geo = "GSE201153"
    shell:
      """
      {input.script} {params.geo} {input.direct}
      touch {output.untar}
      touch {output.tar}
      """

rule remove_GSE175930:
    input:
        script= "code/remove_originals.bash",
        direct=directory("data/GSE175930_organized_morgan/")
    output:
        untar="data/.GSE175930_removed",
        tar="data/.GSE175930.tar_removed"
    params:
        geo = "GSE175930"
    shell:
      """
      {input.script} {params.geo} {input.direct}
      touch {output.untar}
      touch {output.tar}
      """

rule rename_runs:
    input:
        script= "code/rename_runs.R",
        direct_rothenberg=directory("data/GSE201153_organized_rothenberg/"),
        direct_morgan=directory("data/GSE175930_organized_morgan/"),
        meta="data/metadata_morgan/tissue_object_metadata.csv"
    output:
         "data/.runs_renamed_completed"
    shell:
      """
      Rscript {input.script}
      touch {output}  # Create the completion file
      """

