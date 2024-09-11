rule targets:
    input:
        "data/GSE201153.tar"


rule get_geo:
    input:
        script= "code/get_geo.bash"
    output:
        "data/GSE201153.tar"
    shell:
      "{input.script}"