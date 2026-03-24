proj=/scratch/evakrzisnik/desiree_resequencing/environments
mkdir -p "$proj"


### 1_reads_qc nanopack
conda env export -n nanopack --from-history > "$proj/nanopack.yml"
conda list -n nanopack --explicit > "$proj/nanopack_spec.txt"
conda list -n nanopack > "$proj/nanopack_packages.txt"

### minimap
conda env export -n minimap --from-history > "$proj/minimap.yml"
conda list -n minimap --explicit > "$proj/minimap_spec.txt"
conda list -n minimap > "$proj/minimap_packages.txt"

### 3_assembly hifiasm
conda env export -n hifiasm --from-history > "$proj/hifiasm.yml"
conda list -n hifiasm --explicit > "$proj/hifiasm_spec.txt"
conda list -n hifiasm > "$proj/hifiasm_packages.txt"

conda env export -p /users/timg/.conda/envs/gfatools --from-history > "$proj/tim_gfatools.yml"
conda list -p /users/timg/.conda/envs/gfatools --explicit > "$proj/tim_gfatools_spec.txt"
conda list -p /users/timg/.conda/envs/gfatools > "$proj/tim_gfatools_packages.txt"

conda env export -p /users/timg/.conda/envs/seqkit --from-history > "$proj/tim_seqkit.yml"
conda list -p /users/timg/.conda/envs/seqkit --explicit > "$proj/tim_seqkit_spec.txt"
conda list -p /users/timg/.conda/envs/seqkit > "$proj/tim_seqkit_packages.txt"

### merqury
conda env export -n merqury --from-history > "$proj/merqury.yml"
conda list -n merqury --explicit > "$proj/merqury_spec.txt"
conda list -n merqury > "$proj/merqury_packages.txt"

### quast
conda env export -n quast --from-history > "$proj/quast.yml"
conda list -n quast --explicit > "$proj/quast_spec.txt"
conda list -n quast > "$proj/quast_packages.txt"

### dgenies
conda env export -n dgenies --from-history > "$proj/dgenies.yml"
conda list -n dgenies --explicit > "$proj/dgenies_spec.txt"
conda list -n dgenies > "$proj/dgenies_packages.txt"

### seqkit
conda env export -n seqkit --from-history > "$proj/seqkit.yml"
conda list -n seqkit --explicit > "$proj/seqkit_spec.txt"
conda list -n seqkit > "$proj/seqkit_packages.txt"

### omni-c
conda env export -n omni-c --from-history > "$proj/omni-c.yml"
conda list -n omni-c --explicit > "$proj/omni-c_spec.txt"
conda list -n omni-c > "$proj/omni-c_packages.txt"

### syri_old
conda env export -n syri_old --from-history > "$proj/syri_old.yml"
conda list -n syri_old --explicit > "$proj/syri_old_spec.txt"
conda list -n syri_old > "$proj/syri_old_packages.txt"

conda env export -p /users/timg/.conda/envs/dos2unix --from-history > "$proj/tim_dos2unix.yml"
conda list -p /users/timg/.conda/envs/dos2unix --explicit > "$proj/tim_dos2unix_spec.txt"
conda list -p /users/timg/.conda/envs/dos2unix > "$proj/tim_dos2unix_packages.txt"


### yahs
conda env export -n yahs --from-history > "$proj/yahs.yml"
conda list -n yahs --explicit > "$proj/yahs_spec.txt"
conda list -n yahs > "$proj/yahs_packages.txt"

### gaqet
conda env export -p /users/timg/.conda/envs/gaqet --from-history > "$proj/tim_gaqet.yml"
conda list -p /users/timg/.conda/envs/gaqet --explicit > "$proj/tim_gaqet_spec.txt"
conda list -p /users/timg/.conda/envs/gaqet > "$proj/tim_gaqet_packages.txt"