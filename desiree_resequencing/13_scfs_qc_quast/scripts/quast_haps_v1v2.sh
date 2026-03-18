run_quast () {
  local outdir="$1"; shift
  mkdir -p "$outdir"

  quast \
    "$@" \
    -t "$threads" \
    -o "$outdir" \
    --large \
    --eukaryote \
    --k-mer-stats
}


#labels="${asm_a}_hap1,${asm_a}_hap2,${asm_a}_hap3,${asm_a}_hap4,${asm_b}_hap1,${asm_b}_hap2,${asm_b}_hap3,${asm_b}_hap4"

#hap1.*.modified.renamed.chrOnly.fa

#posamezni v2
link_base=/scratch/evakrzisnik/desiree_resequencing/11_agp_editing/outputs

ln -sf $link_base/hap1.*.modified.renamed.chrOnly.fa \
/scratch/evakrzisnik/desiree_resequencing/13_scfs_qc_quast/inputs/v2_hap1_chrOnly.fa

ln -sf $link_base/hap2.*.modified.renamed.chrOnly.fa \
/scratch/evakrzisnik/desiree_resequencing/13_scfs_qc_quast/inputs/v2_hap2_chrOnly.fa

ln -sf $link_base/hap3.*.modified.renamed.chrOnly.fa \
/scratch/evakrzisnik/desiree_resequencing/13_scfs_qc_quast/inputs/v2_hap3_chrOnly.fa

ln -sf $link_base/hap4.*.modified.renamed.chrOnly.fa \
/scratch/evakrzisnik/desiree_resequencing/13_scfs_qc_quast/inputs/v2_hap4_chrOnly.fa

v1_base=/data-repository/genomes/plant_stu/StDesiree_v1/individual_haplotypes

ln -sf $v1_base/hap_1/De_v1_hap1_chrs.fa.gz \
/scratch/evakrzisnik/desiree_resequencing/13_scfs_qc_quast/inputs/v1_hap1_chrOnly.fa.gz

ln -sf $v1_base/hap_2/De_v1_hap2_chrs.fa.gz \
/scratch/evakrzisnik/desiree_resequencing/13_scfs_qc_quast/inputs/v1_hap2_chrOnly.fa.gz

ln -sf $v1_base/hap_3/De_v1_hap3_chrs.fa.gz \
/scratch/evakrzisnik/desiree_resequencing/13_scfs_qc_quast/inputs/v1_hap3_chrOnly.fa.gz

ln -sf $v1_base/hap_4/De_v1_hap4_chrs.fa.gz \
/scratch/evakrzisnik/desiree_resequencing/13_scfs_qc_quast/inputs/v1_hap4_chrOnly.fa.gz

ln -sf /scratch/evakrzisnik/desiree_resequencing/11_agp_editing/outputs/De_v2.chrOnly.fa \
/scratch/evakrzisnik/desiree_resequencing/13_scfs_qc_quast/inputs/De_v2_chrOnly.fa

ln -sf /data-repository/genomes/plant_stu/StDesiree_v1/whole_genome/De_v1_chrs.fa.gz \
/scratch/evakrzisnik/desiree_resequencing/13_scfs_qc_quast/inputs/De_v1_chrOnly.fa.gz

#posamezni hap v2

conda activate quast

threads=40

in_base=/scratch/evakrzisnik/desiree_resequencing/13_scfs_qc_quast/inputs
out_base=/scratch/evakrzisnik/desiree_resequencing/13_scfs_qc_quast/outputs

run_quast "$out_base/v2_haps" \
    "$in_base/v2_hap1_chrOnly.fa" "$in_base/v2_hap2_chrOnly.fa" "$in_base/v2_hap3_chrOnly.fa" "$in_base/v2_hap4_chrOnly.fa" \
    -l "Dev2_hap1,Dev2_hap2,Dev2_hap3,Dev2_hap4"

#posamezni hap v1

run_quast "$out_base/v1_haps" \
    "$in_base/v1_hap1_chrOnly.fa.gz" "$in_base/v1_hap2_chrOnly.fa.gz" "$in_base/v1_hap3_chrOnly.fa.gz" "$in_base/v1_hap4_chrOnly.fa.gz" \
    -l "Dev1_hap1,Dev1_hap2,Dev1_hap3,Dev1_hap4"

#vse samo chr only

run_quast "$out_base/v1_v2_chrOnly" \
    "$in_base/De_v2_chrOnly.fa" "$in_base/De_v1_chrOnly.fa.gz" \
    -l "v2_allchrs,v1_allchrs"


conda deactivate 