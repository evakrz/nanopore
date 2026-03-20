in_base=/scratch/evakrzisnik/desiree_resequencing/15_longread_mapping/inputs
conda activate seqkit
#De_v1.chrOnly.ver1.renamed.fa
#De_v2.chrOnly.ver2.renamed.fa

for fa in "$in_base"/*.renamed.fa; do
    [ -e "$fa" ] || continue
    echo "Indexing: $fa"
    seqkit faidx "$fa"
done

conda deactivate

out_base_old=/scratch/evakrzisnik/desiree_resequencing/7_dgenies/inputs/references
/De_v1_hap1_chrs.fa.gz
#/data-repository/genomes/plant_stu/StDesiree_v1/individual_haplotypes/hap_1/De_v1_hap1_chrs.fa.gz

conda activate seqkit
for hap in 1 2 3 4; do
    for fa in "$out_base_old"/De_v1_hap${hap}.*.modified.renamed.chrOnly.fa; do
        [ -e "$fa" ] || continue
        echo "Indexing: $fa"
        seqkit faidx "$fa"
    done
done
conda deactivate


#rabimo .fai za vse haplogroups
in_base=/scratch/evakrzisnik/desiree_resequencing/15_longread_mapping/inputs
#/DKED/scratch/evakrzisnik/desiree_resequencing/15_longread_mapping/inputs/De_v1.hapgroup_a.fa
conda activate seqkit
#De_v1.chrOnly.ver1.renamed.fa
#De_v2.chrOnly.ver2.renamed.fa

for fa in "$in_base"/*.hapgroup*.fa; do
    [ -e "$fa" ] || continue
    echo "Indexing: $fa"
    seqkit faidx "$fa"
done

conda deactivate

echo "Indexed $(ls $in_base/*.hapgroup*.fa.fai | wc -l) files"