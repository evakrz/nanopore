#sli bomo po vseh agp editing outputih in iz njih pobrali po prvih 12 scaffoldov, da dobimo fasto samo s kromosomi

out_dir=/scratch/evakrzisnik/desiree_resequencing/11_agp_editing/outputs
dgenies_dir=/scratch/evakrzisnik/desiree_resequencing/7_dgenies/inputs/manual_scaffolds

mkdir -p $dgenies_dir

conda activate seqkit


#hočemo, da jih preimenuje po kromosomih

for hap in 1 2 3 4; do
    for in_fa in "$out_dir"/hap${hap}.*.modified.fa; do
        [ -e "$in_fa" ] || continue

        base=$(basename "$in_fa" .fa)
        out_fa="$out_dir/${base}.renamed.fa"

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
done





#now we will use the fasta we just created to extract the first 12 chromosomes with labeled origin haplotype
for file in $out_dir/*.modified.renamed.fa

do

  base=$(basename "$file" .fa)

  #seqkit head -n 10 review.fa > subset.fa
  seqkit head -n 12 $file > $out_dir/$base.chrOnly.fa



  # -------- LINK TO DGENIES --------
  ln -sf "$out_dir/$base.chrOnly.fa" \
  "$dgenies_dir/$base.chrOnly.fa"

  echo "✓ Symlink created:"
  echo "$dgenies_dir/$base.chrOnly.fa"
    
done

#and now we will produce a concatenated v2 genome from these 12 chromosome fastas
out="$out_dir/De_v2.chrOnly.fa"
> "$out"

for i in $(seq -w 1 12); do
  for hap in 1 2 3 4; do
    seqkit grep -r -p "^chr${i}_${hap}$" "$out_dir"/hap${hap}*.chrOnly.fa >> "$out"
  done
done

seqkit seq -n $out_dir/De_v2.chrOnly.fa

conda deactivate

  # -------- LINK TO DGENIES --------
  ln -sf "$out_dir/De_v2.chrOnly.fa" \
  "$dgenies_dir/De_v2.chrOnly.fa"

  echo "✓ Symlink created:"
  echo "$dgenies_dir/De_v2.chrOnly.fa"



#PREVIOUS LOOP VERSIONS

# out=$out_dir/De_v2.chrOnly.fa
# > "$out"   # empty file

# for file in $out_dir/*.chrOnly.fa
# do

# for i in $(seq -w 1 12); do
#     seqkit grep -p "chr${i}_1" $file >> "$out"
#     seqkit grep -p "chr${i}_2" $file >> "$out"
#     seqkit grep -p "chr${i}_3" $file >> "$out"
#     seqkit grep -p "chr${i}_4" $file >> "$out"
# done

# seqkit grep -r -p "^scaffold" $out_base/hap1.renamed.fa >> "$out"
# seqkit grep -r -p "^scaffold" $out_base/hap2.renamed.fa >> "$out"
# seqkit grep -r -p "^scaffold" $out_base/hap3.renamed.fa >> "$out"
# seqkit grep -r -p "^scaffold" $out_base/hap4.renamed.fa >> "$out"








# for hap in 1 2 3 4; do
#     # in_fa="/path/to/hap${hap}.seqkit_temp.16.fa"
#     # out_fa="/path/to/hap${hap}.renamed.fa"
#     in_fa=$out_dir/hap${hap}.*.modified.fa
#     out_fa=$out_dir/hap${hap}.*.modified.renamed.fa
#     #this file still contains all scaffolds, just renames the first 12 chromosomes and scaffold origin
#     #we actually only need the chromosomes, but the scaffolds with origin hap number might also be useful

#     awk -v hap="$hap" '
#     BEGIN {n=0}
#     /^>/{
#         n++
#         if (n <= 12) {
#             printf(">chr%02d_%s\n", n, hap)
#         } else {
#             printf(">scaffold%d_%s\n", n, hap)
#         }
#         next
#     }
#     {print}
#     ' "$in_fa" > "$out_fa"

# done