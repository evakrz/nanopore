#i have linked the seqkit temporary fasta files (with 12 scaffolds for chromosomes and selected debris scaffolds to be arranged)
#they are in in_base and are what we will rename and merge

in_base=/scratch/evakrzisnik/desiree_resequencing/10_scaf_review/input/seqkit_temps
out_base=/scratch/evakrzisnik/desiree_resequencing/10_scaf_review/output/temp_genome

for hap in 1 2 3 4; do
    # in_fa="/path/to/hap${hap}.seqkit_temp.16.fa"
    # out_fa="/path/to/hap${hap}.renamed.fa"
    in_fa=$in_base/hap${hap}.seqkit_temp.fa
    out_fa=$out_base/hap${hap}.renamed.fa

    awk -v hap="$hap" '
    BEGIN {n=0}
    /^>/{
        n++
        if (n <= 12) {
            printf(">chr%02d_%s\n", n, hap)
        } else {
            printf(">scaffold%d_%s\n", n, hap)
        }
        next
    }
    {print}
    ' "$in_fa" > "$out_fa"
done

# cat $out_base/hap1.renamed.fa \
#     $out_base/hap2.renamed.fa \
#     $out_base/hap3.renamed.fa \
#     $out_base/hap4.renamed.fa \
#     >merged_temp_genome.fa

conda activate seqkit 
out=$out_base/merged_ordered.fa
> "$out"   # empty file

for i in $(seq -w 1 12); do
    seqkit grep -p "chr${i}_1" $out_base/hap1.renamed.fa >> "$out"
    seqkit grep -p "chr${i}_2" $out_base/hap2.renamed.fa >> "$out"
    seqkit grep -p "chr${i}_3" $out_base/hap3.renamed.fa >> "$out"
    seqkit grep -p "chr${i}_4" $out_base/hap4.renamed.fa >> "$out"
done

seqkit grep -r -p "^scaffold" $out_base/hap1.renamed.fa >> "$out"
seqkit grep -r -p "^scaffold" $out_base/hap2.renamed.fa >> "$out"
seqkit grep -r -p "^scaffold" $out_base/hap3.renamed.fa >> "$out"
seqkit grep -r -p "^scaffold" $out_base/hap4.renamed.fa >> "$out"

conda deactivate

#we want to align this version to the desiree genome, so we link it into dgenies inputs
dgenies_dir=/scratch/evakrzisnik/desiree_resequencing/7_dgenies/inputs/seqkit_temp

# -------- LINK TO DGENIES --------
ln -sf "$out_base/merged_ordered.fa" \
"$dgenies_dir/temp_genome.fa"


echo "✓ Symlink created:"
echo "$dgenies_dir/temp_genome.fa"