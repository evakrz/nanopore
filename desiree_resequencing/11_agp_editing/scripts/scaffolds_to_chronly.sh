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


#we will also concatenate a kind of all scaffolds genome, we need it for merqury analysis
#it's the same as the temp_genome logic, just that it actually contains all scaffolds
conda activate seqkit 
out_base=/scratch/evakrzisnik/desiree_resequencing/11_agp_editing/outputs
out=$out_base/De_v2.scfs.fa
> "$out"   # empty file

#haps all scfs: .modified.renamed.fa

for i in $(seq -w 1 12); do
    seqkit grep -p "chr${i}_1" $out_base/hap1.*.modified.renamed.fa >> "$out"
    seqkit grep -p "chr${i}_2" $out_base/hap2.*.modified.renamed.fa >> "$out"
    seqkit grep -p "chr${i}_3" $out_base/hap3.*.modified.renamed.fa >> "$out"
    seqkit grep -p "chr${i}_4" $out_base/hap4.*.modified.renamed.fa >> "$out"
done

seqkit grep -r -p "^scaffold" $out_base/hap1.*.modified.renamed.fa >> "$out"
seqkit grep -r -p "^scaffold" $out_base/hap2.*.modified.renamed.fa >> "$out"
seqkit grep -r -p "^scaffold" $out_base/hap3.*.modified.renamed.fa >> "$out"
seqkit grep -r -p "^scaffold" $out_base/hap4.*.modified.renamed.fa >> "$out"

seqkit seq -n $out_base/De_v2.scfs.fa


#we will add another file with prefixes 
#seqkit replace -p "^" -r "v1_" v1.fa > v1_prefixed.fa
v2_chrs=/scratch/evakrzisnik/desiree_resequencing/11_agp_editing/outputs/De_v2.chrOnly.fa
seqkit replace -p "^" -r "v2_" $v2_chrs \
 -o /scratch/evakrzisnik/desiree_resequencing/11_agp_editing/outputs/De_v2.chrOnly.ver2.fa

v1_chrs=/data-repository/genomes/plant_stu/StDesiree_v1/whole_genome/De_v1_chrs.fa.gz
seqkit replace -p "^" -r "v1_" $v1_chrs \
 -o /scratch/evakrzisnik/desiree_resequencing/11_agp_editing/outputs/De_v1.chrOnly.ver1.fa


out_dir=/scratch/evakrzisnik/desiree_resequencing/11_agp_editing/outputs

cat "$out_dir/De_v1.chrOnly.ver1.fa" \
    "$out_dir/De_v2.chrOnly.ver2.fa" \
    > "$out_dir/De_v1v2.chrOnly.joined.fa"

  
seqkit faidx "$out_dir/De_v1v2.chrOnly.joined.fa" \
  v1_chr_01_1 v1_chr_01_2 v1_chr_01_3 v1_chr_01_4 \
  v2_chr01_1  v2_chr01_2  v2_chr01_3  v2_chr01_4 \
  v1_chr_02_1 v1_chr_02_2 v1_chr_02_3 v1_chr_02_4 \
  v2_chr02_1  v2_chr02_2  v2_chr02_3  v2_chr02_4 \
  v1_chr_03_1 v1_chr_03_2 v1_chr_03_3 v1_chr_03_4 \
  v2_chr03_1  v2_chr03_2  v2_chr03_3  v2_chr03_4 \
  v1_chr_04_1 v1_chr_04_2 v1_chr_04_3 v1_chr_04_4 \
  v2_chr04_1  v2_chr04_2  v2_chr04_3  v2_chr04_4 \
  v1_chr_05_1 v1_chr_05_2 v1_chr_05_3 v1_chr_05_4 \
  v2_chr05_1  v2_chr05_2  v2_chr05_3  v2_chr05_4 \
  v1_chr_06_1 v1_chr_06_2 v1_chr_06_3 v1_chr_06_4 \
  v2_chr06_1  v2_chr06_2  v2_chr06_3  v2_chr06_4 \
  v1_chr_07_1 v1_chr_07_2 v1_chr_07_3 v1_chr_07_4 \
  v2_chr07_1  v2_chr07_2  v2_chr07_3  v2_chr07_4 \
  v1_chr_08_1 v1_chr_08_2 v1_chr_08_3 v1_chr_08_4 \
  v2_chr08_1  v2_chr08_2  v2_chr08_3  v2_chr08_4 \
  v1_chr_09_1 v1_chr_09_2 v1_chr_09_3 v1_chr_09_4 \
  v2_chr09_1  v2_chr09_2  v2_chr09_3  v2_chr09_4 \
  v1_chr_10_1 v1_chr_10_2 v1_chr_10_3 v1_chr_10_4 \
  v2_chr10_1  v2_chr10_2  v2_chr10_3  v2_chr10_4 \
  v1_chr_11_1 v1_chr_11_2 v1_chr_11_3 v1_chr_11_4 \
  v2_chr11_1  v2_chr11_2  v2_chr11_3  v2_chr11_4 \
  v1_chr_12_1 v1_chr_12_2 v1_chr_12_3 v1_chr_12_4 \
  v2_chr12_1  v2_chr12_2  v2_chr12_3  v2_chr12_4 \
  > "$out_dir/De_v1v2.chrOnly.ordered.fa"

dgenies_dir=/scratch/evakrzisnik/desiree_resequencing/7_dgenies/inputs/manual_scaffolds

ln -s /scratch/evakrzisnik/desiree_resequencing/11_agp_editing/outputs/De_v1v2.chrOnly.ordered.fa $dgenies_dir/De_v1v2.chrOnly.ordered.fa

ln -s /scratch/evakrzisnik/desiree_resequencing/11_agp_editing/outputs/De_v2.chrOnly.ver2.fa $dgenies_dir/De_v2.chrOnly.ver2.fa

ln -s /scratch/evakrzisnik/desiree_resequencing/11_agp_editing/outputs/De_v1.chrOnly.ver1.fa $dgenies_dir/De_v1.chrOnly.ver1.fa

dgenies_dir=/scratch/evakrzisnik/desiree_resequencing/7_dgenies/inputs/manual_scaffolds
ln -s /scratch/evakrzisnik/desiree_resequencing/11_agp_editing/outputs/De_v1v2.chrOnly.ordered.fa.gz $dgenies_dir/De_v1v2.chrOnly.ordered.fa.gz

conda deactivate


seqkit stats /scratch/evakrzisnik/desiree_resequencing/11_agp_editing/outputs/De_v1v2.chrOnly.ordered.fa
seqkit seq -n /scratch/evakrzisnik/desiree_resequencing/11_agp_editing/outputs/De_v1v2.chrOnly.ordered.fa | wc -l
seqkit seq -n /scratch/evakrzisnik/desiree_resequencing/11_agp_editing/outputs/De_v1v2.chrOnly.ordered.fa | sort | uniq -d

gzip /scratch/evakrzisnik/desiree_resequencing/11_agp_editing/outputs/De_v1v2.chrOnly.ordered.fa
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