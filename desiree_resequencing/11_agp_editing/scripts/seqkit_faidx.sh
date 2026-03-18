out_base=/scratch/evakrzisnik/desiree_resequencing/11_agp_editing/outputs

conda activate seqkit
for hap in 1 2 3 4; do
    for fa in "$out_base"/hap${hap}.*.modified.renamed.chrOnly.fa; do
        [ -e "$fa" ] || continue
        echo "Indexing: $fa"
        seqkit faidx "$fa"
    done
done
conda deactivate